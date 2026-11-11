# Verifier brief

You verify 1 to 3 review claims about one merge request. Each claim is a hypothesis that someone (a reviewer, a bot or a finder agent) made. Treat it as unproven until your own run shows it either way. A claim can be right, partly right or wrong, and a wrong claim found early saves the author a needless change.

Read `evidence.md` and `areas.md` next to this file before you start. `evidence.md` says where you work and what counts as proof. `areas.md` defines the 11 review areas.

## Your task, for each claim

1. **Check the facts.** Split the claim into its factual parts ("X calls Y", "this count includes Z", "this costs N queries"). Prove or disprove each part by running code, with a negative control. When the claim says users see something, show what they see: a request spec, a runner script on dev data, a Jest test of the real component, or the browser for clicks and screens.
2. **Give the verdict:** `confirmed`, `partly_confirmed` (name which parts hold), `refuted` or `inconclusive`.
3. **Name the area** that owns the claim, using the ownership rules in `areas.md` section 3.
4. **Describe the user impact:** what a user of the app sees because of the problem, which users, and how often it happens in real use. Say how you estimated the frequency.
5. **Try the proposed fix**, if the claim proposes one: apply it in memory, run the relevant existing specs with it, and rerun your proof. Report whether it removes the problem and what else it changes.
6. **Look for a better fix:** smaller, closer to an existing pattern in the codebase, or covering more cases. A better fix needs the same proof as the proposed one: the existing specs and your probe pass with it.
7. **Assess the fix against all 11 areas** in `areas.md`. For each area give one line: what the fix does to it, with evidence where you ran something, or `n/a` and why. For Reuse, give the `path:line` of the existing code you compare with. For Simplicity, compare the size of the fix and the alternative (lines, branches, concepts).
8. **Mark `pre_existing`** when the problem exists on the base commit in code the MR did not change.

## Domain view

A domain question ("should an empty record still count in this total?") deserves an answer from what the user expects and from how the rest of the product already behaves; cite the screens or code you compared. The `<project_rules>` block describes the product and its users.

## Examples of the expected judgment

These are short illustrations, not templates.

<example>
Claim: "This total counts archived orders, so it is one too high."
Run: a probe spec that builds the total with and without an archived order. The total goes from 25 to 26 only when the archived order has a refund. Without a refund it stays at 25.
Negative control: with the proposed `active?` guard prepended, the total stays at 25 in both cases.
Verdict: partly_confirmed, confidence 9. The claim holds only for archived orders with a refund.
</example>

<example>
Claim: "This lambda runs on every cache lookup and makes a heavy query."
Run: wrap the lambda with a call counter and run the cache specs and one real lookup in the console. The counter stays at 0; the cache key only checks whether the option is present.
Negative control: the same counter on the other caller counts 34 calls, so the counter works.
Verdict: refuted for the cost part, confidence 10. The lambda is dead code, which is a Simplicity point, not a Performance one.
</example>

## Output

Return the JSON your brief's schema asks for. Fill the evidence fields first and the verdict after them. Keep `explanation` to a few plain sentences: what the claim means, what you found and what you recommend. List every scratch file you left in `<scratch_dir>` and every dev record you created and removed.
