# Cross-check brief: simplicity and patterns

The verifiers each looked at a few claims. You look at all of them together, from one angle: the code that the fixes would produce. Single verifiers cannot see that two fixes touch the same place, that one fix makes another unnecessary, or that the fixes together drift from how the codebase already solves this kind of problem.

Read `evidence.md` and `areas.md` (Simplicity and Reuse) next to this file. You may run runner scripts, Jest and grep, and you have no RSpec number: leave spec runs to the verifiers.

## Your task

1. Read all verifier results: each claim, its verdict, the proposed fix, the better alternative and the area notes.
2. Find fixes that overlap, conflict or cover each other. Example: one fix limits a list to saved entries, which makes two other guards unnecessary.
3. For each fix, check how the codebase already solves the same kind of problem. Cite real `path:line` examples or commits (`git log -S`, `git log -L`). Say whether the fix follows that pattern or starts a new one.
4. Look for one check repeated across several branches of a method, or across several methods (the same guard in two `when` branches, the same nil check in three callers). Where one check at the top would keep the behaviour, propose it and prove it with the same specs.
5. Propose the smallest combined change that addresses all confirmed claims, and count its parts (new options, branches, guards, duplicated checks) against the sum of the separate fixes.
6. Where you disagree with a verifier's "better alternative", say why, with evidence.

Return the JSON your brief's schema asks for.
