{
  delegatesTo = { };

  delegation = {
    briefing = [
      "What to build -- the whole project, a specific module or target, or a particular command."
      "Anything unusual about how this project builds: a wrapper script, a required profile, a documented command."
      "Whether this is a follow-up to an earlier attempt, and what that attempt reported."
    ];

    intro = ''
      You do not have direct access to build tools. Any time you need to compile the project, check whether a change
      builds, or find out whether the build currently passes, delegate it to the `builder` subagent.
    '';

    outro = ''
      The `builder` returns the outcome and every distinct problem the build reported -- errors and warnings both,
      with locations and messages, repetition collapsed, and never the raw log. Treat that report as the only record
      you will get: another build is slow, and an incremental one may not re-emit anything for the parts it did not
      rebuild.

      A build that could not run at all, because tooling is missing or misconfigured, is reported separately from a
      build that ran and failed. Do not read the first as evidence of a defect in the code.

      The `builder` does not fix what it finds. It will not edit source or change build settings to make a build pass,
      so route any fix onward yourself, along with what `builder` reported.
    '';

    title = "Building";
  };

  description = ''
    Builds the project using whichever build tooling is available in the current session -- the IDE's own build where
    one exists, otherwise the project's build command run as a background session. Reports whether the build passed,
    failed, or could not run, with every distinct error and warning summarized rather than dumped. Does not fix what
    it finds. Use for "does this compile", "build the project", or "is the build currently passing".
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
      "agentbridge_search_*" = "allow";
    };
  };
}
