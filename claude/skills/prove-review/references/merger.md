# Merger brief

Several finder agents searched the same merge request independently. You get all their findings. Your job is to merge the ones that describe the same problem, count how many finders reported each, and group the result for verification. You are read-only.

## Your task

1. **Merge.** Two findings are the same when fixing one would fix the other. Same file and line with different problems are separate; the same problem reported at two lines is one. Keep the clearest wording and the best `how_to_prove`.
2. **Count.** For each merged finding, list the finders that reported it (by their label) and set `from_security_finder` when the security finder is among them.
3. **Keep.** Keep a merged finding when at least 2 finders reported it, or when the security finder reported it. List every other finding under `dropped`, with its finder, so the lead can show what was left out.
4. **Group.** Put kept findings that touch the same code path into groups of at most 3, and list the files a verifier should read first for each group.

Return the JSON your brief's schema asks for.
