{
  delegatesTo = {
    researcher = { };
  };

  delegation = {
    briefing = [
      "Exactly what you're looking for (a symbol, a file, a pattern, a piece of behavior) and any known starting point."
      "Scope, if it matters: a specific file/directory/module versus the whole codebase."
      "Whether you need current state only, or also how something changed over time (git history)."
    ];

    intro = ''
      You do not have direct access to code search or navigation tools. Any time you need to find something in the
      codebase, understand how something is structured, or trace how a symbol is used -- delegate it to the
      `code-explorer` subagent rather than trying to reason about the code from memory or guesswork.
    '';

    outro = ''
      The `code-explorer` will return concise findings -- file paths, relevant snippets, and a short synthesis -- not
      full file dumps. It is read-only and cannot make edits, so use it purely to inform decisions, not to carry out
      changes.
    '';

    title = "Codebase exploration";
  };

  description = ''
    Read-only code exploration agent. Searches and navigates the codebase using whichever code-intelligence tools are
    available in the current session -- this can range from basic pattern/file search up to richer semantic navigation
    (symbol lookup, go-to-definition, call/type hierarchies, read-only git history, etc.). Use for "where is X", "what
    calls Y", "how is Z structured", or any question that requires looking at the code without changing it.
  '';

  mode = "subagent";

  permission = {
    both = {
      "*" = "deny";
      "question" = "allow";
      "tools_github-get_commit" = "allow";
      "tools_github-get_file_contents" = "allow";
      "tools_github-get_label" = "allow";
      "tools_github-get_latest_release" = "allow";
      "tools_github-get_me" = "allow";
      "tools_github-get_release_by_tag" = "allow";
      "tools_github-get_tag" = "allow";
      "tools_github-get_teams" = "allow";
      "tools_github-issue_read" = "allow";
      "tools_github-list_branches" = "allow";
      "tools_github-list_commits" = "allow";
      "tools_github-list_issue_fields" = "allow";
      "tools_github-list_issue_types" = "allow";
      "tools_github-list_issues" = "allow";
      "tools_github-list_pull_releases" = "allow";
      "tools_github-list_pull_repository_collaborators" = "allow";
      "tools_github-list_pull_requests" = "allow";
      "tools_github-list_tags" = "allow";
      "tools_github-pull_request_read" = "allow";
      "tools_github-search_code" = "allow";
      "tools_github-search_commits" = "allow";
      "tools_github-search_issues" = "allow";
      "tools_github-search_pull_requests" = "allow";
      "tools_github-search_repositories" = "allow";
      "tools_github-search_users" = "allow";
    };

    default = {
      "bash" = {
        "*" = "deny";
        "git *" = "allow";
      };
      "glob" = "allow";
      "grep" = "allow";
      "read" = "allow";
    };

    intellij = {
      "intellij_download_sources" = "allow";
      "intellij_find_*" = "allow";
      "intellij_get_call_hierarchy" = "allow";
      "intellij_get_class_outline" = "allow";
      "intellij_get_documentation" = "allow";
      "intellij_get_file_*" = "allow";
      "intellij_get_project_*" = "allow";
      "intellij_get_symbol_info" = "allow";
      "intellij_get_type_hierarchy" = "allow";
      "intellij_git_diff" = "allow";
      "intellij_git_log" = "allow";
      "intellij_git_show" = "allow";
      "intellij_go_to_declaration" = "allow";
      "intellij_list_directory_tree" = "allow";
      "intellij_list_external_dirs" = "allow";
      "intellij_list_project_files" = "allow";
      "intellij_read_file" = "allow";
      "intellij_search_*" = "allow";
    };
  };

  temperature = 1.0;
  top_k = 64;
  top_p = 0.95;
}
