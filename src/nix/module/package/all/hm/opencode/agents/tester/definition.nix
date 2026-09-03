{
  delegatesTo = { };

  delegation = {
    briefing = [
      "What to test -- the whole suite, or a specific group, class, or individual test."
      "Where it is, if the request does not already make that clear."
      "Anything genuinely unusual about how it is tested that you know and `tester` could not discover for itself."
      "Whether this is a follow-up to an earlier run, and what that run reported."
    ];

    intro = ''
      You do not have direct access to test tools. Any time you need to run tests, check whether a change breaks
      anything, or find out whether the suite currently passes, delegate it to the `tester` subagent.

      The `tester` works out how to run them for itself, using tooling you cannot see. You do not need to determine what
      kind of project it is, find its test configuration, or decide which command should run; investigating in order to
      tell it those things produces a guess that is worse than what it can establish directly. Say what to test and
      where, and leave the mechanism to it.
    '';

    outro = ''
      The `tester` returns the outcome, counts of how many tests ran, passed, failed, and were skipped, and every
      distinct failure with its name, location, and cause. Treat that report as the only record you will get: another
      run is slow, and a failure that came and went may not reproduce.

      A run that could not start at all, because tooling is missing or misconfigured, is reported separately from a run
      that executed and failed. Do not read the first as evidence of a defect in the code. A run that selected no tests
      is likewise reported as such rather than as a pass.

      The `tester` does not fix what it finds. It will not edit source, change a test, or adjust configuration to make a
      run pass, so route any fix onward yourself, along with what `tester` reported.
    '';

    title = "Running Tests";
  };

  description = ''
    Runs the project's tests using whichever test tooling is available in the current session -- the whole suite, or a
    specific group, class, or individual test. Reports whether they passed, failed, or could not run, with counts and
    every distinct failure summarized rather than dumped. Does not fix what it finds. Use for "run the tests", "does
    this break anything", or "is the suite currently passing".
  '';

  mode = "subagent";

  model = "llm/task";

  permission = {
    both = {
      "*" = "deny";
      "pty_*" = "allow";
      "skill" = {
        "*" = "deny";
        "global-run-command" = "allow";
      };
    };

    default = {
      "glob" = "allow";
      "grep" = "allow";
      "read" = "allow";
    };

    intellij = {
      "agentbridge_build_project" = "allow";
      "agentbridge_find_*" = "allow";
      "agentbridge_list_directory_tree" = "allow";
      "agentbridge_list_external_dirs" = "allow";
      "agentbridge_list_project_files" = "allow";
      "agentbridge_read_build_output" = "allow";
      "agentbridge_read_file" = "allow";
      "agentbridge_read_run_output" = "allow";
      "agentbridge_run_tests" = "allow";
      "agentbridge_search_*" = "allow";
    };
  };
}
