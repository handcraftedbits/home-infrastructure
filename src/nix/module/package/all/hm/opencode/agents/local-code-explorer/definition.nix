{
  delegatesTo = {
    web-explorer = { };
  };

  delegation = {
    briefing = [
      "Exactly what you're looking for (a symbol, a file, a pattern, a piece of behavior) and any known starting point."
      "Scope, if it matters: a specific file/directory/module versus the whole codebase."
      "Whether you need current state only, or also how something changed over time (git history)."
    ];

    intro = ''
      You do not have direct access to code search or navigation tools. Any time you need to find something in the local
      codebase, understand how something is structured, or trace how a symbol is used -- delegate it to the
      `local-code-explorer` subagent rather than trying to reason about the code from memory or guesswork.
    '';

    outro = ''
      The `local-code-explorer` will return concise findings -- file paths, relevant snippets, and a short synthesis --
      not full file dumps. It is read-only and cannot make edits, so use it purely to inform decisions, not to carry out
      changes.
    '';

    title = "Local Codebase Exploration";
  };

  description = ''
    Read-only local code exploration agent. Searches and navigates the local codebase using whichever code-intelligence
    tools are available in the current session -- this can range from basic pattern/file search up to richer semantic
    navigation (symbol lookup, go-to-definition, call/type hierarchies, read-only git history, etc.). Use for "where is
    X", "what calls Y", "how is Z structured", or any question that requires looking at the code without changing it.
  '';

  mode = "subagent";

  permission = {
    both = {
      "*" = "deny";
    };

    default = {
      "bash" = "allow";
      "glob" = "allow";
      "grep" = "allow";
      "read" = "allow";
    };

    intellij = {
      "agentbridge_download_sources" = "allow";
      "agentbridge_find_*" = "allow";
      "agentbridge_get_call_hierarchy" = "allow";
      "agentbridge_get_class_outline" = "allow";
      "agentbridge_get_documentation" = "allow";
      "agentbridge_get_file_*" = "allow";
      "agentbridge_get_project_*" = "allow";
      "agentbridge_get_symbol_info" = "allow";
      "agentbridge_get_type_hierarchy" = "allow";
      "agentbridge_git_diff" = "allow";
      "agentbridge_git_log" = "allow";
      "agentbridge_git_show" = "allow";
      "agentbridge_go_to_declaration" = "allow";
      "agentbridge_list_directory_tree" = "allow";
      "agentbridge_list_external_dirs" = "allow";
      "agentbridge_list_project_files" = "allow";
      "agentbridge_read_file" = "allow";
      "agentbridge_search_*" = "allow";
    };
  };
}
