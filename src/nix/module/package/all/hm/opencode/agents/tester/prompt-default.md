# Test Tooling in This Session

There is no test tool here, so you run the tests yourself. Work out the project's own test command from what is in the
repository, start it as a background session using the `global-run-command` skill, and take the results from that
session's buffer. Never run a suite as a blocking call: test runs are exactly the long, chatty processes that hang one,
and you have no blocking shell tool available in any case.

Express the selection using the build tool's own filter rather than inventing one. Every build tool has a way to name a
single class, a single method, or a package, and that mechanism already understands this project's layout. Find the
syntax from the project's configuration, its documentation, or the tool's own help output instead of recalling a flag
that looks right -- a filter with the wrong shape usually selects nothing rather than failing.

Watch for exactly that. A run that selected no tests almost always exits zero and prints a summary that reads like
success. Check how many tests actually executed before you believe a pass, and when that number is zero, report that
the selection matched nothing rather than that the tests passed.

Set `timeoutSeconds` generously. A suite takes longer than it looks, and the point of running it in the background is
that the wait costs you nothing.

Results arrive as text in the session buffer rather than as counts you are handed, so you have to read them out. Filter
for the summary line and for failures rather than paging the whole log, and quote each failure from what the run
actually printed instead of paraphrasing it.

Read and search the repository with `read`, `grep`, and `glob`.
