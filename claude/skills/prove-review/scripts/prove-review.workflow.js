// ABOUTME: Workflow script for the prove-review skill: verifiers, skeptics and cross-checks, plus finders in find mode.
// ABOUTME: The lead passes all data in `args`; agents read their briefs from the skill's references folder.

export const meta = {
  name: 'prove-review',
  description: 'Prove or disprove MR review claims by running code, then challenge confident verdicts',
  whenToUse: 'Started by the prove-review skill after setup; not for direct use',
  phases: [
    { title: 'Find', detail: 'find mode only: independent finders, then a merge' },
    { title: 'Verify', detail: 'one verifier per claim group, then a skeptic per confident verdict' },
    { title: 'Cross-check', detail: 'simplicity and patterns, user impact' },
  ],
}

const AREAS = [
  'security', 'data_integrity', 'regression', 'concurrency', 'correctness', 'robustness',
  'deploy_safety', 'performance', 'reuse', 'simplicity', 'test_quality',
]

const str = { type: 'string' }
const int = { type: 'integer' }
const bool = { type: 'boolean' }
const strs = { type: 'array', items: str }
const obj = (properties) => ({
  type: 'object',
  additionalProperties: false,
  required: Object.keys(properties),
  properties,
})
const arr = (items) => ({ type: 'array', items })
const oneOf = (values) => ({ type: 'string', enum: values })

const COMMAND = obj({ cmd: str, exit_code: int, output_excerpt: str })

const CLAIM_RESULT = obj({
  claim_id: str,
  area: oneOf(AREAS),
  commands_run: arr(COMMAND),
  negative_control: obj({ description: str, cmd: str, output_excerpt: str }),
  evidence_locations: strs,
  proof_grade: oneOf(['verified', 'structural', 'predicted']),
  verdict: oneOf(['confirmed', 'partly_confirmed', 'refuted', 'inconclusive']),
  confidence: int,
  holds_when: str,
  user_impact: obj({ who: str, what_they_see: str, how_often: str, basis: str }),
  pre_existing: bool,
  proposed_fix_result: str,
  better_alternative: str,
  area_notes: arr(obj({ area: oneOf(AREAS), note: str })),
  explanation: str,
})

const VERIFIER_SCHEMA = obj({
  claims: arr(CLAIM_RESULT),
  scratch_files: strs,
  dev_data_changes: str,
})

const SKEPTIC_SCHEMA = obj({
  claim_id: str,
  commands_run: arr(COMMAND),
  outcome: oneOf(['refuted', 'could_not_refute', 'inconclusive']),
  breaking_case: str,
  explanation: str,
})

const SIMPLICITY_SCHEMA = obj({
  overlaps: arr(obj({ claim_ids: strs, observation: str })),
  pattern_checks: arr(obj({
    claim_id: str, existing_pattern: str, follows: oneOf(['yes', 'no', 'n/a']), evidence: str,
  })),
  combined_change: obj({ description: str, parts_combined: int, parts_separate: int }),
  disagreements: arr(obj({ claim_id: str, note: str })),
})

const IMPACT_SCHEMA = obj({
  ranking: arr(obj({
    claim_id: str, rank: int, who: str, what_they_see: str, how_often: str, basis: str, if_not_fixed: str,
  })),
})

const FINDER_SCHEMA = obj({
  findings: arr(obj({
    title: str, area: oneOf(AREAS), path: str, line: int, claim: str, how_to_prove: str, pre_existing: bool,
  })),
})

const MERGER_SCHEMA = obj({
  claims: arr(obj({
    claim_id: str, statement: str, area: oneOf(AREAS), path: str, line: int, proposed_fix: str,
    how_to_prove: str, finders: strs, from_security_finder: bool, pre_existing: bool,
  })),
  groups: arr(obj({ group_id: str, claim_ids: strs, files_to_read: strs })),
  dropped: arr(obj({ finder: str, title: str, reason: str })),
})

// The general finders start from different places so that their mistakes differ;
// the security finder's single reports are kept (see merger.md).
const FINDERS = [
  { label: 'finder-flow', focus: 'Start from the entry points the user hits (controllers, API endpoints, jobs) and follow the changed code paths downwards.' },
  { label: 'finder-data', focus: 'Start from the data layer (models, queries, migrations, caches, db/structure.sql) and work upwards to the callers.' },
  { label: 'finder-frontend', focus: 'Start from the last file of the diff and work backwards; read the frontend and the responses it consumes with extra care.' },
  { label: 'finder-security', focus: 'Look only at the Security area, with the checklist in areas.md and the security rules of the project profile. Report every candidate, even one you alone would find.' },
]

const a = args
const refs = `${a.skill_dir}/references`
const effort = a.effort || {}
const SKEPTIC_MIN_CONFIDENCE = a.skeptic_min_confidence ?? 8
const readOnlyAgentType = a.read_only_agent_type || 'Explore'

const environment = (label, testEnvNumber) => `<environment>
worktree: ${a.worktree}
app_url: ${a.app_url}
base_sha: ${a.base_sha}
head_sha: ${a.head_sha}
diff: git -C ${a.worktree} diff ${a.base_sha}..${a.head_sha}
label: ${label}
scratch_dir: ${a.scratch_root}/${label}
test_env_number: ${testEnvNumber ?? 'none: do not run RSpec'}
</environment>
<mr_intent>
${a.intent}
</mr_intent>
<project_rules>
${a.project_rules || 'No project profile.'}
</project_rules>`

const verifierPrompt = (group, testEnvNumber) => `${environment(`verify-${group.group_id}`, testEnvNumber)}
<claims>
${JSON.stringify(group.claims, null, 2)}
</claims>
<files_to_read_first>
${(group.files_to_read || []).join('\n')}
</files_to_read_first>

Read ${refs}/verifier.md and follow it; it tells you to read evidence.md and areas.md in the same folder. Verify each claim in <claims> and return the result for every claim_id.`

const skepticPrompt = (claim, result, group, testEnvNumber) => `${environment(`skeptic-${claim.claim_id}`, testEnvNumber)}
<claim>
${JSON.stringify(claim, null, 2)}
</claim>
<evidence_from_other_agent>
${JSON.stringify({
  evidence_locations: result.evidence_locations,
  commands_run: result.commands_run,
  negative_control: result.negative_control,
}, null, 2)}
</evidence_from_other_agent>

Read ${refs}/skeptic.md and follow it. Test whether this evidence settles the claim, and run the strongest check that would come out differently if the claim were wrong.`

const crossPrompt = (brief, label, results) => `${environment(label, null)}
<verifier_results>
${JSON.stringify(results, null, 2)}
</verifier_results>

Read ${refs}/${brief} and follow it.`

const finderPrompt = (finder) => `${environment(finder.label, null)}
<focus>
${finder.focus}
</focus>

Read ${refs}/finder.md and follow it. You are read-only.`

const mergerPrompt = (findings) => `<finder_results>
${JSON.stringify(findings, null, 2)}
</finder_results>

Read ${refs}/merger.md and follow it.`

async function findGroups() {
  phase('Find')
  const results = await parallel(FINDERS.map((f) => () =>
    agent(finderPrompt(f), {
      label: f.label, phase: 'Find', schema: FINDER_SCHEMA,
      agentType: readOnlyAgentType, effort: effort.finder || 'medium',
    }).then((r) => r && { finder: f.label, findings: r.findings })))
  const found = results.filter(Boolean)
  log(`${found.length}/${FINDERS.length} finders returned ${found.reduce((n, r) => n + r.findings.length, 0)} findings`)
  if (!found.some((r) => r.findings.length)) return { groups: [], dropped: [] }

  const merged = await agent(mergerPrompt(found), {
    label: 'merger', phase: 'Find', schema: MERGER_SCHEMA,
    agentType: readOnlyAgentType, effort: effort.finder || 'medium',
  })
  const byId = Object.fromEntries(merged.claims.map((c) => [c.claim_id, c]))
  const groups = merged.groups.map((g) => ({
    group_id: g.group_id,
    files_to_read: g.files_to_read,
    claims: g.claim_ids.map((id) => byId[id]).filter(Boolean).map((c) => ({ ...c, kind: 'behaviour' })),
  }))
  log(`kept ${merged.claims.length} findings in ${groups.length} groups; dropped ${merged.dropped.length}`)
  return { groups, dropped: merged.dropped, finder_results: found }
}

// Each worker owns one TEST_ENV_NUMBER and runs its groups one after another,
// so two RSpec runs never share a number.
async function verifyGroups(groups) {
  phase('Verify')
  const queue = [...groups]
  const workers = a.test_env_numbers.map((n) => async () => {
    const done = []
    while (queue.length) {
      const group = queue.shift()
      const verifier = await agent(verifierPrompt(group, n), {
        label: `verify-${group.group_id}`, phase: 'Verify', schema: VERIFIER_SCHEMA,
        effort: effort.verifier || 'high',
      })
      const skeptics = []
      for (const result of verifier ? verifier.claims : []) {
        const confident = result.verdict !== 'inconclusive' && result.confidence >= SKEPTIC_MIN_CONFIDENCE
        const claim = group.claims.find((c) => c.claim_id === result.claim_id)
        if (!confident || !claim) continue
        skeptics.push(await agent(skepticPrompt(claim, result, group, n), {
          label: `skeptic-${result.claim_id}`, phase: 'Verify', schema: SKEPTIC_SCHEMA,
          effort: effort.skeptic || 'high',
        }))
      }
      done.push({ group, verifier, skeptics: skeptics.filter(Boolean) })
    }
    return done
  })
  return (await parallel(workers)).filter(Boolean).flat()
}

let found = null
let groups = a.groups || []
if (a.mode === 'find') {
  found = await findGroups()
  groups = found.groups
}
if (!groups.length) {
  log('no claims to verify')
  return { mode: a.mode, found, verified: [], cross: null }
}

const verified = await verifyGroups(groups)
const missing = groups.filter((g) => !verified.some((v) => v.group.group_id === g.group_id && v.verifier))
if (missing.length) log(`no verifier result for groups: ${missing.map((g) => g.group_id).join(', ')}`)

phase('Cross-check')
const results = verified.filter((v) => v.verifier).map((v) => ({ group_id: v.group.group_id, claims: v.group.claims, results: v.verifier.claims }))
const [simplicity, impact] = await parallel([
  () => agent(crossPrompt('cross-simplicity.md', 'cross-simplicity', results), {
    label: 'cross-simplicity', phase: 'Cross-check', schema: SIMPLICITY_SCHEMA, effort: effort.cross || 'high',
  }),
  () => agent(crossPrompt('cross-impact.md', 'cross-impact', results), {
    label: 'cross-impact', phase: 'Cross-check', schema: IMPACT_SCHEMA, effort: effort.cross || 'high',
  }),
])

return { mode: a.mode, found, verified, missing_groups: missing.map((g) => g.group_id), cross: { simplicity, impact } }
