// ABOUTME: Tests the prove-review workflow script with fake agents: worker pool, skeptic selection and find mode.
// ABOUTME: Run with `node test-workflow.mjs`; it loads the script text and replaces agent() and friends with stubs.
import { readFileSync } from 'node:fs'
import { fileURLToPath } from 'node:url'
import { dirname, join } from 'node:path'
import assert from 'node:assert/strict'

const here = dirname(fileURLToPath(import.meta.url))
const source = readFileSync(join(here, 'prove-review.workflow.js'), 'utf8').replace(/^export const meta/m, 'const meta')
const AsyncFunction = Object.getPrototypeOf(async () => {}).constructor
const script = new AsyncFunction('args', 'agent', 'parallel', 'phase', 'log', source)

const sleep = (ms) => new Promise((r) => setTimeout(r, ms))
const parallel = async (thunks) => Promise.all(thunks.map((t) => t().catch(() => null)))

function harness(respond) {
  const calls = []
  const running = new Map()
  let overlap = false
  const agent = async (prompt, opts) => {
    const n = (prompt.match(/test_env_number: (\d+)/) || [])[1]
    if (n) {
      if (running.get(n)) overlap = true
      running.set(n, true)
    }
    calls.push({ prompt, opts })
    await sleep(5)
    if (n) running.set(n, false)
    return respond(prompt, opts)
  }
  return { agent, calls, overlap: () => overlap }
}

const claimResult = (claim_id, verdict, confidence) => ({
  claim_id, area: 'correctness', commands_run: [{ cmd: 'bin/rspec x', exit_code: 1, output_excerpt: 'boom' }],
  negative_control: { description: 'base', cmd: 'bin/rspec x', output_excerpt: 'ok' }, evidence_locations: ['a.rb:1'],
  proof_grade: 'verified', verdict, confidence, holds_when: '', user_impact: { who: 'x', what_they_see: 'y', how_often: 'z', basis: 'b' },
  pre_existing: false, proposed_fix_result: 'SECRET_FIX_RESULT', better_alternative: '', area_notes: [],
  explanation: 'SECRET_EXPLANATION',
})

const baseArgs = {
  skill_dir: '/skill', worktree: '/wt', app_url: 'http://s1.localhost:3010', base_sha: 'b', head_sha: 'h',
  scratch_root: '/scratch', intent: 'Show accounts.', test_env_numbers: ['11', '1'],
}

const verdicts = { c1: ['confirmed', 9], c2: ['refuted', 8], c3: ['confirmed', 7], c4: ['inconclusive', 10], c5: ['partly_confirmed', 9] }
const respondVerify = (prompt, opts) => {
  if (opts.label.startsWith('verify-')) {
    const ids = [...prompt.matchAll(/"claim_id": "(c\d)"/g)].map((m) => m[1])
    return { claims: ids.map((id) => claimResult(id, ...verdicts[id])), scratch_files: [], dev_data_changes: 'none' }
  }
  if (opts.label.startsWith('skeptic-')) return { claim_id: opts.label.slice(8), commands_run: [], outcome: 'could_not_refute', breaking_case: '', explanation: '' }
  if (opts.label === 'cross-simplicity') return { overlaps: [], pattern_checks: [], combined_change: { description: '', parts_combined: 1, parts_separate: 2 }, disagreements: [] }
  if (opts.label === 'cross-impact') return { ranking: [] }
  throw new Error(`unexpected agent ${opts.label}`)
}

const groups = [
  { group_id: 'g1', files_to_read: ['a.rb'], claims: [{ claim_id: 'c1', statement: 's1' }, { claim_id: 'c2', statement: 's2' }] },
  { group_id: 'g2', files_to_read: [], claims: [{ claim_id: 'c3', statement: 's3' }] },
  { group_id: 'g3', files_to_read: [], claims: [{ claim_id: 'c4', statement: 's4' }, { claim_id: 'c5', statement: 's5' }] },
]

let failures = 0
async function test(name, fn) {
  try {
    await fn()
    console.log(`ok   - ${name}`)
  } catch (e) {
    failures++
    console.log(`FAIL - ${name}\n       ${e.message.split('\n')[0]}`)
  }
}

await test('verify mode: every group is verified and two agents never share a test number', async () => {
  const h = harness(respondVerify)
  const out = await script({ ...baseArgs, mode: 'verify', groups }, h.agent, parallel, () => {}, () => {})
  assert.deepEqual(out.verified.map((v) => v.group.group_id).sort(), ['g1', 'g2', 'g3'])
  assert.equal(h.overlap(), false)
  assert.deepEqual(out.missing_groups, [])
})

await test('skeptics run only for verdicts with confidence >= 8 that are not inconclusive', async () => {
  const h = harness(respondVerify)
  await script({ ...baseArgs, mode: 'verify', groups }, h.agent, parallel, () => {}, () => {})
  const skeptics = h.calls.filter((c) => c.opts.label.startsWith('skeptic-')).map((c) => c.opts.label).sort()
  assert.deepEqual(skeptics, ['skeptic-c1', 'skeptic-c2', 'skeptic-c5'])
})

await test('a skeptic never sees the verdict, confidence, explanation or fix result', async () => {
  const h = harness(respondVerify)
  await script({ ...baseArgs, mode: 'verify', groups }, h.agent, parallel, () => {}, () => {})
  for (const c of h.calls.filter((x) => x.opts.label.startsWith('skeptic-'))) {
    assert.doesNotMatch(c.prompt, /SECRET_|"verdict"|"confidence"/)
    assert.match(c.prompt, /bin\/rspec x/)
  }
})

await test('the skeptic minimum confidence can be changed', async () => {
  const h = harness(respondVerify)
  await script({ ...baseArgs, mode: 'verify', groups, skeptic_min_confidence: 10 }, h.agent, parallel, () => {}, () => {})
  assert.equal(h.calls.filter((c) => c.opts.label.startsWith('skeptic-')).length, 0)
})

await test('both cross-check agents get all verifier results and no test number', async () => {
  const h = harness(respondVerify)
  const out = await script({ ...baseArgs, mode: 'verify', groups }, h.agent, parallel, () => {}, () => {})
  const cross = h.calls.filter((c) => c.opts.label.startsWith('cross-'))
  assert.equal(cross.length, 2)
  for (const c of cross) {
    for (const id of ['c1', 'c2', 'c3', 'c4', 'c5']) assert.match(c.prompt, new RegExp(`"${id}"`))
    assert.match(c.prompt, /test_env_number: none/)
  }
  assert.ok(out.cross.simplicity && out.cross.impact)
})

await test('a verifier that dies is reported as a missing group', async () => {
  const h = harness((p, o) => (o.label === 'verify-g2' ? null : respondVerify(p, o)))
  const out = await script({ ...baseArgs, mode: 'verify', groups }, h.agent, parallel, () => {}, () => {})
  assert.deepEqual(out.missing_groups, ['g2'])
})

await test('agents get the effort the lead asks for', async () => {
  const h = harness(respondVerify)
  await script({ ...baseArgs, mode: 'verify', groups, effort: { verifier: 'xhigh' } }, h.agent, parallel, () => {}, () => {})
  assert.equal(h.calls.find((c) => c.opts.label === 'verify-g1').opts.effort, 'xhigh')
  assert.equal(h.calls.find((c) => c.opts.label === 'skeptic-c1').opts.effort, 'high')
})

const finding = (title, path) => ({ title, area: 'correctness', path, line: 1, claim: title, how_to_prove: 'spec', pre_existing: false })
const respondFind = (mergedClaims) => (prompt, opts) => {
  if (opts.label.startsWith('finder-')) return { findings: opts.label === 'finder-security' ? [] : [finding('dup', 'a.rb')] }
  if (opts.label === 'merger') {
    return {
      claims: mergedClaims,
      groups: mergedClaims.length ? [{ group_id: 'm1', claim_ids: mergedClaims.map((c) => c.claim_id), files_to_read: ['a.rb'] }] : [],
      dropped: [],
    }
  }
  return respondVerify(prompt, opts)
}
const mergedClaim = { claim_id: 'c1', statement: 'dup', area: 'correctness', path: 'a.rb', line: 1, proposed_fix: '', how_to_prove: 'spec', finders: ['finder-flow', 'finder-data'], from_security_finder: false, pre_existing: false }

await test('find mode: four read-only finders, a merge, then verification of the merged groups', async () => {
  const h = harness(respondFind([mergedClaim]))
  const out = await script({ ...baseArgs, mode: 'find' }, h.agent, parallel, () => {}, () => {})
  const finders = h.calls.filter((c) => c.opts.label.startsWith('finder-'))
  assert.equal(finders.length, 4)
  for (const f of finders) assert.equal(f.opts.agentType, 'Explore')
  assert.equal(h.calls.find((c) => c.opts.label === 'merger').opts.agentType, 'Explore')
  assert.deepEqual(out.verified.map((v) => v.group.group_id), ['m1'])
  assert.equal(out.verified[0].group.claims[0].statement, 'dup')
})

await test('find mode with no kept findings stops before verification', async () => {
  const h = harness(respondFind([]))
  const out = await script({ ...baseArgs, mode: 'find' }, h.agent, parallel, () => {}, () => {})
  assert.deepEqual(out.verified, [])
  assert.equal(h.calls.filter((c) => c.opts.label.startsWith('verify-')).length, 0)
})

await test('find mode uses the read-only agent type from the profile', async () => {
  const h = harness(respondFind([mergedClaim]))
  await script({ ...baseArgs, mode: 'find', read_only_agent_type: 'my-reviewer' }, h.agent, parallel, () => {}, () => {})
  for (const c of h.calls.filter((x) => x.opts.label.startsWith('finder-') || x.opts.label === 'merger')) assert.equal(c.opts.agentType, 'my-reviewer')
})

await test('every agent that runs code gets the project rules; finders get them too', async () => {
  const h = harness(respondFind([mergedClaim]))
  await script({ ...baseArgs, mode: 'find', project_rules: 'RULE_FROM_PROFILE' }, h.agent, parallel, () => {}, () => {})
  for (const c of h.calls.filter((x) => x.opts.label !== 'merger')) assert.match(c.prompt, /<project_rules>\s*RULE_FROM_PROFILE\s*<\/project_rules>/, c.opts.label)
})

console.log(failures ? `\n${failures} failed` : '\nall passed')
process.exit(failures ? 1 : 0)
