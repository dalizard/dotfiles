---
name: deep-review
description: Multi-agent deep review of a GitLab merge request. Use when given an MR URL or ID to review thoroughly; findings are consolidated and never posted to the MR.
---

When invoked with a Merge Request URL or ID, execute the following autonomous workflow:

1. Fetch the MR diff, description, and related context.
2. Create an agent team to explore the MR from different angles. Spawn 5 teammates to review the code:
   - **Security Reviewer:** Scan for vulnerabilities and unsafe data handling.
   - **Performance Reviewer:** Identify performance bottlenecks. You MUST require benchmark verification and provide measured variance for any performance claims.
   - **Test Coverage Reviewer:** Propose concrete testing scenarios strictly modeled on existing specs (e.g., RSpec/Playwright) in this repository.
   - **Pattern Conformance Reviewer:** Search the codebase. You MUST provide `grep` evidence that a recommended pattern already exists in other places before suggesting it to the user.
   - **Regression Risk Reviewer:** Analyze recent squash commits and `git blame` for related changes that might conflict.
3. Run a **Critic Agent** teammate to play devil's advocate -- evaluate all subagent findings. The Critic MUST reject and filter out any finding that lacks a specific `file:line` citation, lacks measured evidence, or constitutes generic best-practice advice not grounded in this codebase.
4. Output a single consolidated review containing:
   - Blocking issues, architectural concerns, and minor nits (in that order).
   - Explicit confidence levels (HIGH/MED/LOW) for every claim.
   - Exact `file:line` citations for all feedback.
   - DO NOT post any comments to the Merge Request.
