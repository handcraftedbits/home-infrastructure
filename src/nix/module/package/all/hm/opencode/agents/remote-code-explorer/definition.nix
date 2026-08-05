{
  delegatesTo = {
    web-explorer = { };
  };

  delegation = {
    briefing = [
      "Exactly what you need to know, and about which project, library, or repository."
      ''
        The version that matters, if any -- a tag, release, or commit. Without one you'll get whatever the default
        branch says today, which may not be what's actually in use.
      ''
      "Whether a summary is enough, or you need exact content such as a file, a signature, or a config snippet."
    ];

    intro = ''
      You do not have direct access to code outside this repository. Any time you need to know how a third-party
      library, dependency, or upstream project actually works -- what a function does, what changed in a release, why
      an issue was closed -- delegate it to the `remote-code-explorer` subagent rather than recalling it from memory.
    '';

    outro = ''
      The `remote-code-explorer` will return concise findings with sources, citing a repository, ref, and path where
      one applies. It is read-only, and it cannot see the local codebase -- for anything in the working tree you need
      `local-code-explorer` instead.
    '';

    title = "Remote and Third-Party Code Exploration";
  };

  description = ''
    Read-only exploration agent for code outside the local codebase -- third-party libraries, dependencies, and upstream
    projects. Queries GitHub directly for file contents, search, commits, releases, issues, and pull requests, and
    reaches the wider web for projects hosted elsewhere. Use for "how does library X implement Y", "what changed in
    version Z", "is this a known upstream issue", or any question about code you don't own.
  '';

  mode = "subagent";

  model = "task/gemma4-e4b";

  permission = {
    both = {
      "*" = "deny";
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
      "webfetch" = "allow";
    };
  };

  temperature = 1.0;
  top_k = 64;
  top_p = 0.95;
}
