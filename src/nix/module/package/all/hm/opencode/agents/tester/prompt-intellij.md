# Test Tooling in This Session

`agentbridge_run_tests` runs tests through the IDE's own test runner. Its `target` is a class, or a `class.method`, and
it is required -- there is no way to ask for everything by leaving it out. `module`, `test_task`, and `timeout` are
optional.

A plain class name is enough. "Run the tests for `WatchlistValidatorTest`" needs no resolution step, because the tool
discards any package you give it and searches the project for a class with that simple name. Do not go looking for a
fully qualified name you were not given. Do use the fully qualified form when you already have it: before searching for
any code, the tool first matches your target as a *substring* against the names of existing run configurations, and a
short bare name can collide with an unrelated one there.

Because the package is discarded before that search, a simple name that exists in more than one package resolves to
whichever the search reaches first, and nothing tells you it was ambiguous. Where that is a real possibility, check with
the search tools before running, and say in your report which class you actually ran.

There is no way to select tests by package. A pattern target is glob-matched against simple class names taken from test
file names, never against a package or a path, so a package-shaped target such as `com.foo.bar.*` matches nothing.
Treat wildcards generally as a last resort: a simple-name glob like `*Test` is the one shape the pattern path supports,
and it drops through whenever it matches nothing or the IDE's JUnit configuration type cannot be found. What it drops
through to is a Gradle test configuration, built unconditionally -- there is no Maven or other build-tool path in the
tool at all -- so on a project that is not Gradle an unresolved target produces a failure that reads like a broken
project rather than like a bad guess.

To run a package, enumerate its test classes with the search tools and run them by name. Naming each class one at a
time is the supported way to cover a package, and it keeps the structured results you get from a resolved target. It is
not free: each class is a separate blocking run capped at 170 seconds, plus its own `agentbridge_read_run_output` call
and its own runner startup, and the totals are yours to add up rather than something the tool reports.

So weigh it by size. For a few classes, running them individually is the better trade. Once a package is larger than
that, or when the brief is the whole suite, run the project's own test command as a background session using the
`global-run-command` skill and let the build tool apply the filter -- one process, one set of totals, and no per-class
ceiling. Take the results from that session's buffer.

Whichever way you go, report totals across everything you ran and name the classes it covered. Several green runs are
not the same claim as a green package.

What `agentbridge_run_tests` returns is usually a stub: a line naming the run and pointing at the IDE's Run panel. The
actual results are in the run tab, which is named after the target -- `Test: <target>`. Read it with
`agentbridge_read_run_output`, passing that name as `tab_name`, `offset: 0` to read from the beginning, and `max_chars`
to bound how much comes back. Always name the tab: left to itself the tool returns whichever tab is most recent, which
need not be the run you just started. Treat the stub as confirmation that the run happened, never as the result, and
never report an outcome you have not actually read.

`agentbridge_build_project` and `agentbridge_read_build_output` are there for when a build has to happen separately,
though the test runner compiles what it needs on its own.

Read and search the repository with `agentbridge_read_file`, `agentbridge_search_*`, `agentbridge_find_*`,
`agentbridge_list_project_files`, `agentbridge_list_directory_tree`, and `agentbridge_list_external_dirs`.
