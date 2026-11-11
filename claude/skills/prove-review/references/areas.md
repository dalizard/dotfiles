# Review areas

Every finding belongs to exactly one of these 11 areas; section 3 says which. [J] marks a rule that comes from judgment, not a source. Sources: research-2026-11-11.md. The examples use a Rails and Vue stack; the project profile adds the project's own rules per area, and those rules count as part of this file.

## 1. Definitions

Each area has: a definition, what it covers, what it does not cover (and which area owns that), the one question the reviewer answers, and the proof that counts.

**Security** (tenant isolation included)
- Definition: an actor can read, change or block something outside their authorisation, or the change weakens a security control.
- Covers: a missing authorization check or policy scope on an endpoint, queries without the tenant scope in a multi-tenant app, tenant data in caches or class-level memoization, SQL built by string interpolation, output marked safe (`html_safe`, `raw`, `v-html`) on user data, template output escaping, strong params and mass assignment, insecure direct object references, open redirects, deserializing untrusted input (`YAML.load`, `Marshal.load`), secrets in logs, CSRF, uploads, new dependencies.
- Does not cover: a logic bug that gives no actor more access (Correctness).
- Question: can a user, another tenant or an outside attacker get something they are not authorised for?
- Proof: a request spec as a user of tenant A that reads or writes tenant B data, or succeeds with a role that lacks the permission; a payload that renders without escaping.

**Data integrity** (money precision included)
- Definition: stored data stays valid, consistent and exact after any sequence of operations, including a failure halfway.
- Covers: transactions around writes to several rows, database constraints and unique indexes versus model validations only, bulk updates that skip callbacks, data changes in migrations, soft delete, exact decimal types for money (never floating point), rounding.
- Does not cover: two runs at the same time (Concurrency).
- Question: can this change leave wrong or half-written data in the database?
- Proof: a spec that raises halfway and shows a partial row; a floating point versus decimal difference on real amounts.

**Regression**
- Definition: behaviour that worked on the base commit, and that the MR did not mean to change, is different or broken on the head commit.
- Covers: other callers of a changed method, scope, partial or component; changed defaults; changed API or serializer shape; a removed guard; changed template output; a CSS class used elsewhere; work moved between the database and application code; a specific error handler replaced by a generic one.
- Does not cover: new behaviour that is wrong (Correctness); old and new code running together during the deploy (Deploy safety).
- Question: which existing caller or user now sees a different result, and was that difference intended?
- Proof: a spec that passes on the base commit and fails on the head commit, or the same request or render with different output on base and head.

**Concurrency**
- Definition: the code stays correct when two requests, threads or jobs run it at the same time.
- Covers: check-then-act without a lock or unique index, `find_or_create_by` without a unique index, class variables or class-level memoization in a multi-threaded server, shared state in a job process, a job enqueued before its transaction commits, a stale read from a replica after a write.
- Does not cover: a single run that is wrong (Correctness).
- Question: what happens when two of these run at the same moment?
- Proof: a spec with two threads or two database connections that reproduces the race, or a code path that shows shared mutable state at class level.

**Correctness** (domain fit included)
- Definition: for every input and state the contract allows, the changed code gives the result that the intent requires. The intent is the issue, the MR description and the specs.
- Covers: wrong logic, off-by-one and date or period boundaries, wrong sign, wrong scope or filter, `nil` from a nullable column, empty lists, wrong computed or watcher logic in the frontend, a wrong translation key, code that does not do what the ticket asks, counts that disagree between screens.
- Does not cover: invalid input or a failed dependency (Robustness); unintended change to old behaviour (Regression).
- Question: is there a valid input for which the new behaviour is not what the intent says?
- Proof: a spec written from the intent that fails on head, or a console script with input, actual output and expected output.

**Robustness**
- Definition: the code works, or fails safely and visibly, when it gets invalid input, a missing record or a failed dependency.
- Covers: `rescue` that swallows errors; missing timeouts or retries on HTTP clients; jobs that are not safe to run twice (most job systems run a job at least once); a record deleted before the job runs; parameter validation at the API edge; partial failure across external calls; frontend error and loading states. For external services, also: limits and `Retry-After`, idempotency, empty response versus 404, pagination.
- Does not cover: cost (Performance); exploitability (Security); two runs at once (Concurrency).
- Question: what happens when this input is invalid or this dependency fails, and is the result safe, visible and recoverable?
- Proof: a spec that injects the fault (an HTTP stub that times out or answers 500, a missing record, the job performed twice) and shows an unhandled error, silently wrong state or no error report.

**Deploy safety**
- Definition: old and new code run safely side by side during a rolling deploy, and a revert is safe.
- Covers: job argument shape in both directions, schema changes that old code cannot handle (expand, then contract), ignored columns, cache key changes and how much cache they empty, frontend assets versus API response shape, feature flags, the rollback text in the MR.
- Does not cover: behaviour after the deploy is complete (the other areas).
- Question: what breaks or slows down while old and new code run together, and when the change is reverted?
- Proof: a spec that performs the job with the argument shape from base; base specs run against the head schema; cache keys computed for base and head.

**Performance**
- Definition: the resource cost of the changed code (queries, time, memory, payload size) at production data sizes.
- Covers: N+1 queries, missing indexes (check the schema file first), loads that grow without limit (`.all`, `pluck`, `to_a`), queries in loops, cache hit rate and key granularity, heavy work in a request that belongs in a job, reads that could go to a replica, large reactive arrays in the frontend, bundle size, job fan-out.
- Does not cover: behaviour on failure, including timeout handling (Robustness).
- Question: how does the cost grow with N, and is it acceptable at production N?
- Proof: query count and time at N=1 and N=10 (or larger) on base and on head, from the framework's SQL notifications; `EXPLAIN (ANALYZE)` on representative data. A local plan is not proof of the production plan. Never state a size you did not measure.

**Reuse**
- Definition: the change does not duplicate, bypass or contradict an abstraction or convention that already exists in this codebase.
- Covers: hand-written code where a helper, concern, service, scope or component exists; a new HTTP client wrapper; a serializer style other than the one the codebase uses; a frontend approach the codebase is moving away from; hard-coded UI strings where the codebase translates them; new gems or frameworks; a new pattern where the codebase has a history of a different one (for example how cache invalidation is done).
- Does not cover: complexity with no existing counterpart (Simplicity).
- Question: does the repo already have a way to do this, and does the change use it?
- Proof: the `path:line` of the existing code, and the specs passing with it. No `path:line`, no finding.

**Simplicity** (readability and naming included)
- Definition: the change adds no complexity that the problem does not need. Complexity is whatever makes the code hard to understand or change: more places to edit for one change, more to keep in mind, hidden effects.
- Covers: abstractions for needs nobody has, options nothing uses, thin wrapper classes, deep nesting, flag arguments, mixed concerns, unclear names, comments that repeat the code, dead code, the same check repeated in several places.
- Does not cover: an equivalent that already exists in the repo (Reuse).
- Question: is there a smaller design, with fewer concepts, that passes the same specs?
- Proof: a concrete smaller alternative that keeps the behaviour (sketch or in-memory patch with the specs green), and a count: fewer lines, branches or concepts. No alternative, no finding.

**Test quality**
- Definition: the specs in the change fail when the changed behaviour breaks, and they test real behaviour.
- Covers: changed branches with no spec, specs that only test mocks, new factories where fixtures exist, time handling that makes a spec flaky, a spec that reaches the service but not the controller path the user takes, fixtures that would also pass with a weaker check (for example a cross-tenant spec whose other tenant differs in more than the one boundary under test).
- Does not cover: defects in production code (the other areas).
- Question: if I break the changed line, does a spec fail?
- Proof: break the production line in memory (remove a guard, flip a condition) and show which specs still pass.

## 2. Merged or rejected candidates

- Tenant isolation: inside Security as a required checklist, because it is the same failure class as broken access control.
- Money precision: inside Data integrity.
- Maintainability, readability, naming: inside Simplicity and Reuse.
- User impact and domain fit: not an area. Every finding states what the user sees and how often (the `user_impact` field), and the user-impact agent ranks them.
- Observability: rejected [J]. Swallowed errors belong to Robustness, secrets in logs to Security. Judging log and metric coverage from a diff produces many low-value comments.
- Accessibility and i18n: hard-coded strings go to Reuse, wrong text to Correctness [J].

## 3. Who owns a finding

Boundary rules:
- Correctness or Robustness: decided by the trigger. An input or state the contract allows (including `nil` in a nullable column, empty lists) is Correctness. Invalid input, a missing record or a failed dependency is Robustness.
- Correctness or Regression: behaviour that existed on base and was not meant to change is Regression. New or intended behaviour is Correctness.
- Simplicity or Reuse: if the fix names an existing symbol in the repo, it is Reuse.
- Performance or Robustness: "how much does it cost" is Performance; "what happens when it fails" is Robustness.
- Security or Correctness: if any actor gets something outside their authorisation, it is Security, even when the cause is a plain logic bug.

Tie-breaker [J]: the first area in this order whose question the finding answers "yes": Security, Data integrity, Regression, Concurrency, Correctness, Robustness, Deploy safety, Performance, Reuse, Simplicity, Test quality. Worse consequence wins.
