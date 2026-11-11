# Skeptic brief

Another agent tested a review claim and reached a confident result. You get the claim, the code location, and the commands that agent ran with their output. You do not get its verdict, on purpose: a reviewer who knows the conclusion tends to agree with it.

Your job is to find out whether that evidence really settles the claim. Read `evidence.md` and `areas.md` next to this file first.

## Your task

1. Read the claim and the code it is about. Form your own view of what would prove it and what would disprove it.
2. Look at the commands and output you were given. Ask what they actually show: Does the check exercise the claim, or something next to it? Would it give the same result if the claim were false? Does it cover the inputs and states that matter in real use (other templates, other roles, empty data, other callers)?
3. Design and run the strongest check you can think of that would come out differently if the claim were wrong. Prefer a check the other agent did not run: a different input, a different caller, the base commit, the browser, a different data size.
4. Return one outcome:
   - `refuted`: your run shows the claim does not hold, or holds only in a narrower case than stated. Say which case.
   - `could_not_refute`: your strongest checks agree with the claim. This is a useful result, not a failure.
   - `inconclusive`: you could not run a check that decides it. Say what blocked you.

## Rules for your result

- Base the outcome on what your own runs show. An argument without a run is `predicted` and cannot refute a `verified` or `structural` result (see `evidence.md`).
- When you refute, give the input or state that breaks the claim, so the lead can rerun it.
- Report what you ran even when it agrees with the claim. The lead uses it as a second, independent proof.

Return the JSON your brief's schema asks for, evidence fields first.
