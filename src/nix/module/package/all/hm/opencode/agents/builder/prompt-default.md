# Build Tooling in This Session

There is no build tool here, so you run the build yourself. Start it as a background session and follow it to
completion using the `global-run-command` skill, and take the problems you report from that session's buffer. Never run
a build as a blocking call: builds are exactly the long, chatty processes that hang one, and you have no blocking shell
tool available in any case.

Read and search the repository with `read`, `grep`, and `glob` to work out what the project's own build command is.
