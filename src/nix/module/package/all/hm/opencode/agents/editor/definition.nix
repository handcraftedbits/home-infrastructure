{
  delegatesTo = { };

  delegation = {
    briefing = [
      "Which files to change, by path."
      "What each change is, specified precisely enough that it can be made without inferring intent."
      "The exact behavior, signature, value, or wording you want -- not just the goal you are after."
      "The context those changes depend on: surrounding behavior, naming conventions, why the change is being made."
      "Anything deliberately out of scope, if the files contain adjacent things that look like they also need fixing."
    ];

    intro = ''
      You do not have direct access to file editing tools. Any time a task involves changing the contents of a file --
      code, configuration, data, anything on disk -- or renaming, moving, or deleting one, delegate it to the `editor`
      subagent.

      The `editor` can read the files it is editing, so you do not need to pass their full contents. What it will not do
      is work out for itself what the change should be. It does not explore the codebase, and a vague instruction will
      come back as a question rather than an edit, so decide what the change is first and hand it over fully specified.
    '';

    outro = ''
      The `editor` will report back the files it changed and a summary of the edits, along with anything it was asked to
      change but did not, and anything it noticed that was outside its scope. It makes only the changes it was briefed
      on, so if its report is missing something you expected, the brief was incomplete -- re-delegate with the missing
      detail rather than assuming it was done silently.
    '';

    title = "File Editing";
  };

  description = ''
    Applies described changes to specific files -- code, configuration, data, or any other file on disk -- and, where
    the available tooling supports it, renames, moves, and deletes files and applies structural refactors. Works from a
    detailed brief supplied by the caller rather than exploring the codebase or deciding what should change. Use for
    "make this change to these files" once the change itself is already determined.
  '';

  mode = "subagent";

  model = "llm/task";

  permission = {
    both = {
      "*" = "deny";
    };

    default = {
      "edit" = "allow";
      "glob" = "allow";
      "grep" = "allow";
      "read" = "allow";
    };

    intellij = {
      "agentbridge_delete_file" = "allow";
      "agentbridge_edit_text" = "allow";
      "agentbridge_find_file" = "allow";
      "agentbridge_format_code" = "allow";
      "agentbridge_insert_*" = "allow";
      "agentbridge_list_directory_tree" = "allow";
      "agentbridge_optimize_imports" = "allow";
      "agentbridge_read_file" = "allow";
      "agentbridge_refactor" = "allow";
      "agentbridge_rename_file" = "allow";
      "agentbridge_search_*" = "allow";
      "agentbridge_write_file" = "allow";
    };
  };
}
