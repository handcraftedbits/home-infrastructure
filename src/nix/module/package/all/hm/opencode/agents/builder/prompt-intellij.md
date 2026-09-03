# Build Tooling in This Session

Use `agentbridge_build_project`. It builds the project the way this environment builds it -- its modules, its targets,
the settings it is configured with -- and reproduces what a build here normally does. Read what it produced with
`agentbridge_read_build_output`, and take the problems you report from there. Do not compose a command line while
`agentbridge_build_project` can do the job, and do not reach past it because running the build yourself feels more
direct or more familiar.

Run the build yourself only when `agentbridge_build_project` cannot express what you were asked to build. Start it as a
background session and follow it to completion using the `global-run-command` skill, and take the problems you report
from that session's buffer instead. Never run a build as a blocking call: builds are exactly the long, chatty processes
that hang one.

Read and search the repository with `agentbridge_read_file`, `agentbridge_search_*`, `agentbridge_find_*`,
`agentbridge_list_project_files`, `agentbridge_list_directory_tree`, and `agentbridge_list_external_dirs`.
