{
  delegatesTo = {
    image-interpreter = { };
    remote-code-explorer = { };
    web-explorer = { };
  };

  delegation = {
    briefing = [
      ''
        The question itself, stated as precisely as you can, along with why you're asking if that narrows what counts as
        a good answer.
      ''
      ''
        How much effort to spend: `quick`, `standard`, or `exhaustive`. `researcher` defaults to standard, which
        cross-checks the claims a conclusion turns on -- say so explicitly when a question is worth more or less than
        that.
      ''
      "Anything you already know: sources you trust or have ruled out, versions that matter, answers you've discarded."
      ''
        What you'll do with the answer, if it affects the shape -- a decision to make, a claim to verify, an approach to
        compare.
      ''
    ];

    intro = ''
      For questions that need more than a single lookup -- comparing approaches, establishing why something behaves the
      way it does, checking a claim that several sources might disagree about -- delegate to the `researcher` subagent.
      It plans an investigation, runs several lines of inquiry in parallel, and reconciles what conflicts.
    '';

    outro = ''
      The `researcher` returns a synthesized answer with its sources and an explicit note of what it could not verify.
      It is slower and costlier than a direct lookup, so send it questions that genuinely need investigating rather than
      single facts. It reaches the web and external repositories only -- it cannot see the local codebase or any
      database.
    '';

    title = "Research and Investigation";
  };

  description = ''
    Investigates open-ended or contested questions that need more than one lookup to answer well. Plans the
    investigation, delegates gathering to explorer subagents in parallel, and reconciles conflicting sources into a
    single answer with citations and stated confidence. Use for "why does X behave this way", "compare X and Y", "is
    this claim true", or any question worth cross-checking. Specify effort as quick, standard, or exhaustive; standard
    is the default.
  '';

  mode = "subagent";

  permission = {
    both = {
      "*" = "deny";
    };
  };
}
