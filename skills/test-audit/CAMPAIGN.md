# Test audit campaign

Use campaign mode only for an explicitly requested assessment or remediation of a whole
subsystem. Apply [SKILL.md](SKILL.md) to each batch. Name the subsystem and its production
boundaries before expanding scope. Include tests outside the subsystem directory when they cover
its production owners, shared boundaries, integration paths, or QA behavior. Resolve uncertain
ownership before including another subsystem.

Keep a resumable working record in a user-selected location or the project's scratch area. Use
`tmp/test-audit-<subsystem>.md` when no scratch convention exists. Reuse a record for the same
scope; do not overwrite unrelated notes or commit the record unless asked. A read-only assessment
keeps its record in the response unless file output was authorized. Never put temporary campaign
notes in `.second_brain/`.

## Gates before edits

Complete these gates in order. Do not edit production or test files until the baseline, inventory,
per-test assessment, and layer plan are complete. If one part is blocked, continue read-only work
on unaffected parts, but leave the dependent gate open and do not begin its edits.

1. **Scope and baseline.** Record the scope, exclusions, authorization, repository revision, and
   dirty state that affects the in-scope behavior, including untracked files. Discover all
   in-scope test files, including tests outside the subsystem directory that cover its boundaries.
   Record the baseline commands, discovery and CI selection, production LOC, test LOC, and
   test-support LOC. Run the baseline across every discovered file and record a result per file.
   List executed failures separately for diagnosis. A blocked or skipped result leaves this gate
   incomplete, as does a file without a recorded result.
2. **Inventory and ownership.** Inventory every declaration in the discovered test files and
   record relevant discovery and CI configuration. Assign every test declaration exactly one
   production owner and name the contract or contracts its assertions protect. Record parameter
   rows separately when their evidence or disposition differs. For a cross-boundary test,
   identify its one owner and list the other contracts it exercises. If inventory reveals another
   in-scope test file, reopen gate 1 and record its baseline result before continuing.
3. **Per-test assessment.** Assess every inventoried declaration against the audit evidence in
   [SKILL.md](SKILL.md). Record what it proves, evidence, and one disposition: retain, repair,
   consolidate, or delete. Name a retained or replacement test when coverage moves. A test that
   did not run remains unresolved.
4. **Layer plan.** Reread the inventory and evidence in a second, read-only planning pass. For each
   contract affected by removal or consolidation, name the retained suite and test cases that will
   protect it, and the failure each catches. List assertions that must move or be rewritten before
   deleting their current tests. Identify support code that becomes removable and check its
   production callers. Record required test-discovery or CI changes. Do not delete coverage until
   its replacement is in place.

The working record can use one row per test declaration with its owner, contract, baseline result,
disposition, evidence, retained or replacement test, support-code effect, and validation status.
Split parameter rows only when the decision or evidence differs. Include baseline and final
production, test, and test-support LOC using the same scope and counting method. Include additions,
deletions, and moves, including untracked files, by category.

An assessment-only request ends after the layer plan. Keep it read-only, report the recommended
dispositions and remaining gaps, and state plainly that remediation was not performed. Do not
report remediation as complete.

## Remediation batches

After all four pre-edit gates pass, work in focused batches around one production owner or contract.
Apply the disposition and layer plan, including any needed replacements or assertion moves before
deleting old coverage. Serialize edits to shared fixtures, helpers, or other test support. Update
test discovery and CI selection with each affected batch. Reconcile the record with current source,
tests, dirty state, discovery, and CI before resuming after intervening changes; revisit evidence
and results those changes affect.

Keep baseline failures visible. Do not change product behavior unless the user authorized that
fix. For an authorized product fix, run the same harness before and after and record both results.
Otherwise report the defect as pending and out of scope. Do not call a failing, blocked, or skipped
check a pass.

After each batch, run its owning and affected sibling checks, then have an eligible non-author
reviewer use `auto-review` to compare removed coverage with the named retained suite and contracts.
The review must check that moved assertions and support-code removals preserve the planned
behavior, and that discovery and CI still select the retained tests. Reuse an eligible existing
reviewer or independent review when it covers this batch's evidence. Follow the repository's
reviewer and model rules; campaign mode does not authorize launching agents. One independent
review that checks the preservation evidence can also satisfy the required `auto-review` for the
batch. Do not add a nested review loop. If an eligible review is unavailable or not authorized,
leave the batch review pending.

For each contract whose protection is restored after review finds a gap, deliberately mutate the
production behavior and show that the retained test fails for the intended reason. A failure for
another reason leaves the proof incomplete. Isolate each mutation. Preserve the exact
pre-mutation bytes of every source file it touches. Restore those bytes immediately after the run,
even if the test fails or the run is interrupted, then verify them byte for byte. Rerun the
retained test against the restored pre-mutation working state, including any existing local edits.
If exact restoration, the mutation, or the post-restoration passing proof cannot be verified or
completed, mark the proof incomplete and pending. Do not overwrite pre-existing work.

## Completion

Before final checks, reconcile the record with the current revision, dirty state, scope, test
files, discovery, and CI. Assess intervening changes and their regression coverage, then rerun any
affected checks. Run the complete in-scope subsystem suite and relevant discovery and CI checks
after that reconciliation. Record a result for every in-scope test file, list failures separately,
and leave blocked or skipped checks unresolved. Any change after these checks invalidates affected
proof until rerun. Report final LOC using the baseline scope and method, and identify additions,
deletions, and moves in production, tests, and test support.

The coverage assessment is complete only when every in-scope declaration has an owner and
disposition, and the read-only layer plan names retained protection for every contract affected
by removal. Remediation is complete only when authorized batches have the required validation and
preservation review, all required mutation proofs pass, test discovery and CI select the retained
suite, and the final subsystem checks are recorded. Unresolved failures, blocked checks, skipped
checks, or reviews remain pending; report their exact scope and evidence instead of claiming full
verification. Retained tests count as completed work. Do not set deletion quotas or use test or LOC
reductions as acceptance criteria.

Campaign mode and its scratch record do not authorize Git operations, branch changes, commits,
publishing, or extra agents. Follow the user's and repository's existing permissions and Git
rules. Do not prescribe a fixed branch, merge, or rebase sequence.
