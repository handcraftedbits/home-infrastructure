{
  delegatesTo = { };

  delegation = {
    briefing = [
      "Exactly what needs to be found or answered."
      ''
        How much effort to spend: a quick single check versus a thorough, cross-checked investigation. The
        `researcher`'s effort level comes entirely from what you tell it, so don't leave this vague if it matters.
      ''
      "Any specific sources or constraints you already know about."
    ];

    intro = ''
      You do not have direct access to web search or page-fetching tools. Any time you need information from the web --
      a fact check, a search, reading a URL -- delegate it to the `researcher` subagent.
    '';

    outro = ''
      The `researcher` will return a distilled, synthesized answer with source URLs -- expect a summary, not raw search
      results or full page dumps.
    '';

    title = "Research and web content";
  };

  description = ''
    Handles web search and page-fetching without polluting the primary session's context. Use for any question requiring
    web search or reading external pages. Invoke with a clear statement of what's needed and how much effort to spend
    (e.g. "quick check", "just confirm X", "thorough -- cross-check 3+ sources").
  '';

  mode = "subagent";

  model = "task/gemma4-e4b";

  permission = {
    both = {
      "*" = "deny";
      "tools_jina-*" = "allow";
      "tools_searxng-searxng_web_search" = "allow";
    };
  };

  temperature = 1.0;
  top_k = 64;
  top_p = 0.95;
}
