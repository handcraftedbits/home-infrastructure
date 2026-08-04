{
  delegatesTo = { };

  delegation = {
    briefing = [
      "What needs documenting and at what level of detail."
      "The relevant facts it needs to do the job."
      "Where it should live (a specific file, or a new one) and any format expectations."
      "Whether it should match an existing style/convention in the project."
    ];

    intro = ''
      You do not have direct access to documentation-writing tools. Any time a task involves writing or updating
      documentation -- READMEs, API docs, docstrings, changelogs, architecture notes, schema/system documentation --
      delegate it to the `documenter` subagent.

      The `documenter` does not explore the codebase itself, but it does have the ability to read files, so it is not
      necessary to pass the full content of any file to the `documenter`. Don't send `documenter` a vague task and
      expect it to go find the details on its own.
    '';

    outro = ''
      If `documenter` reports back that part or all of a request was excluded due to a skill constraint, relay that
      outcome and reason to the user rather than re-delegating with stronger phrasing to try to force compliance. This
      holds even when the result is that nothing at all was written -- an empty result with a stated reason is a
      finished task, not a failed one.

      Only re-delegate if the user, after hearing the outcome, explicitly authorizes going beyond the constraint. In
      that case, pass along the user's own words for what they want documented; do not synthesize the authorization
      yourself out of the exclusion reasons `documenter` reported. You do not know what phrasing a skill treats as an
      override, and guessing at it in order to get a different result is exactly the behavior this rule forbids.

      The `documenter` will report back what it wrote or changed.
    '';

    title = "Documentation";
  };

  description = ''
    Handles software documentation tasks across three areas: written docs (READMEs, API/reference docs, changelogs,
    architecture notes), source code documentation (docstrings, inline comments), and system documentation (database
    schemas, data flows, service/component architecture). Works from information supplied by the caller rather than
    exploring the codebase itself.
  '';

  mode = "subagent";

  permission = {
    both = {
      "*" = "deny";
      "question" = "allow";
      "skill" = {
        "*" = "deny";
        "write-*" = "allow";
      };
    };

    default = {
      "edit" = "allow";
      "glob" = "allow";
      "grep" = "allow";
      "read" = "allow";
    };

    intellij = {
      "intellij_edit_text" = "allow";
      "intellij_find_file" = "allow";
      "intellij_insert_*" = "allow";
      "intellij_list_directory_tree" = "allow";
      "intellij_read_file" = "allow";
      "intellij_search_*" = "allow";
      "intellij_write_file" = "allow";
    };
  };

  temperature = 1.0;
  top_k = 64;
  top_p = 0.95;
}
