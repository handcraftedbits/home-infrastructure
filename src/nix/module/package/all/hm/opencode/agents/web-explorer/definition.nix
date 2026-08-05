{
  delegatesTo = { };

  delegation = {
    briefing = [
      "Exactly what needs to be found or answered."
      ''
        Whether a quick lookup will do or you want the best result or two read carefully. `web-explorer` works lean
        unless you say otherwise, and will not go looking beyond what you asked for.
      ''
      "Any specific sources or constraints you already know about."
    ];

    intro = ''
      You do not have direct access to web search or page-fetching tools. Any time you need a specific piece of
      information from the web -- a fact check, a search, reading a URL -- delegate it to the `web-explorer` subagent.
    '';

    outro = ''
      The `web-explorer` will return a distilled, synthesized answer with source URLs -- expect a summary, not raw
      search results or full page dumps. It answers from a single pass of looking: it does not plan an investigation,
      pursue a question across many sources, or reconcile sources that disagree. When a question needs that, it will say
      so and return what it found rather than going further on its own.
    '';

    title = "Web Search and Page Content";
  };

  description = ''
    Handles web search and page-fetching without polluting the primary session's context. Use for direct lookups: a fact
    check, finding a page, reading a known URL. Answers in a single pass from what it finds, so questions needing
    cross-checking, conflict resolution, or several independent lines of inquiry belong elsewhere. Invoke with a clear
    statement of what's needed (e.g. "quick check", "just confirm X", "read this page and summarize Y").
  '';

  mode = "subagent";

  model = "task/gemma4-e4b";

  permission = {
    both = {
      "*" = "deny";
      "tools_jina-web_fetch" = "allow";
      "tools_searxng-searxng_web_search" = "allow";
      "webfetch" = "allow";
    };
  };

  temperature = 1.0;
  top_k = 64;
  top_p = 0.95;
}
