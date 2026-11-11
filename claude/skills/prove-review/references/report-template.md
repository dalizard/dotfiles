# Report template

The lead writes two things from the workflow result: a short summary in the terminal and the full report file. Both follow the writing rules in the project profile, and by default: plain words, no em dashes, no jargon. Write for a reader who knows the product but not this code.

## Terminal summary

```
<one sentence: how many claims, how many hold, what matters most>

## Per comment (or finding), in priority order from the user-impact ranking

**<id>. <short title>** - <verdict word>, <confidence>/10
- What it means: <the comment in plain words, one or two sentences>
- Why it is there: <the problem the reviewer saw>
- Does it hold: <what the runs showed, without code detail; note "partly" cases>
- Worth fixing: <domain view and code view, one or two sentences>
- Action: <fix as proposed | use the better alternative: ... | no change, because ...>

## Priority list
1. ... (most user impact first; wording and cleanup last)

## Where the agents disagreed
- <claim>: <who said what>, <the check the lead ran>, <the result>

## Found but not caused by this MR
- <pre-existing problems, or "none">

## Cost
<number of agents by kind, wall-clock time, test numbers used>

Full report: <path>
```

## Report file

Path: the report folder from the project profile (default `_docs/` in the main checkout), file `REVIEW_MR<iid>_<YYYY-MM-DD>.md`, or `REVIEW_<branch>_<YYYY-MM-DD>.md` for a local branch.

```
# Review of MR !<iid> (<head sha>) on <date>

Mode: <verify comments | find problems>. Base <sha>, head <sha>. Worktree <path>. Scratch <path>.

## Summary
<the terminal summary, unchanged>

## Claims
### <id>. <title>
- Source: <reviewer and discussion id, or finders>
- Claim (as rewritten by intake): <statement> at <path:line>
- Original comment: <quoted body, marked as the reviewer's words>
- Area: <area>. Verdict: <verdict>, confidence <n>, proof grade <grade>. Holds when: <...>
- Evidence: <command> -> <output excerpt> (exit <code>)
- Negative control: <description>: <command> -> <output excerpt>
- Skeptic: <outcome>, <what it ran>, <breaking case if any>
- Lead's rerun: <command> -> <matches | differs: ...>
- User impact: <who>, <what they see>, <how often> (basis: <...>)
- Proposed fix: <result of trying it>
- Better alternative: <...>
- Area notes: <one line per area that applies>
- Draft reply: <a short reply for the author to post, following the writing rules: what was found and what will change, or why not>

## Cross-checks
- Simplicity and patterns: <overlaps, combined change with part counts, pattern evidence, disagreements>
- User impact ranking: <table>

## Dropped
- <find mode: findings reported by one general finder only, with finder and title>
- <intake: comments with no claim, with reason>

## Run details
Agents and their labels, efforts, test numbers, scratch files, dev data created and removed, groups with no result.
```
