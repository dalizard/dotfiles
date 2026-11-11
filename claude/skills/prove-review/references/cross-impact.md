# Cross-check brief: user impact

The verifiers each looked at a few claims. You look at all of them together, from the user's side: who notices each problem, what they see, and how often. Your ranking decides the order in which the author reads the results.

Read `evidence.md` next to this file. You may run runner scripts on dev data, Jest, and the browser. You have no RSpec number.

## Your task

1. Read all verifier results.
2. For each confirmed or partly confirmed claim, state:
   - who sees it (the user roles from the project profile, an admin, or nobody);
   - what they see, in one sentence a support agent would understand;
   - how often, with the basis of the estimate (which data shape triggers it, and whether you checked how common that shape is in dev data or fixtures);
   - what happens if it is not fixed: wrong numbers, a dead click, a slow page, nothing visible.
3. Where a verifier's description of user impact is a guess, check it: open the screen, or count how many records in dev data have the triggering shape.
4. Rank all claims, refuted ones included (they rank last), from most to least user impact. Claims with no user impact (wording, dead code) rank after the visible ones, ordered by how much they help the next developer.

Return the JSON your brief's schema asks for.
