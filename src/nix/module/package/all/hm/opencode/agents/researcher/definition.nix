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

      Apply that test to the whole question, before you break it up. Almost anything can be split into parts that are
      each a single lookup, so a question that looks simple once decomposed is not evidence that it was simple. The
      decomposition is the planning `researcher` does, and doing it yourself fixes a plan in place before you know what
      any source says -- the parts you did not think to ask about stay unasked.

      Judge by what answering takes, not by how the request was worded. If you find yourself running lookups one after
      another, each shaped by what the last returned, that is an investigation you are conducting by hand, and handing
      it over is worth doing even partway through.
    '';

    outro = ''
      The `researcher` returns a synthesized answer with its sources and an explicit note of what it could not verify.

      It is slower than a direct lookup, so a single fact you could confirm in one place does not need it. That is not a
      reason to break a question that does need investigating into pieces small enough to look up individually: that
      trades one reconciled answer for several unreconciled ones, and a gap in any of them is invisible to you.

      It reaches the web and external repositories only -- it cannot see the local codebase or any database.
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
