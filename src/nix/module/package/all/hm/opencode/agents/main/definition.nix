{
  delegatesTo = {
    builder = {
      note = ''
        Pass constraints, not command lines. `builder` knows how this project builds and which tooling to reach for,
        so an invocation you assembled to save it the trouble replaces its judgment with yours -- and a composed
        command line is the very thing it would otherwise have avoided. What does belong in the brief is anything
        that genuinely constrains the build and that `builder` cannot discover for itself: a profile the user asked
        for, a flag this task requires, a switch an earlier attempt showed was necessary, or a command the user gave
        you verbatim. State what has to be true and let `builder` find the invocation that satisfies it.

        `builder` does not fix what it finds and will not route a fix onward. When it reports failures, send the fix
        to `editor` yourself, passing along what `builder` reported, since that report is the only record you get.
        Build again afterwards only if you need the result confirmed -- re-delegating an unchanged build produces the
        same failure more slowly.

        Its reporting rules are its own. You do not need to tell it to lead with the outcome, to include warnings, or
        to collapse repetition; it already does all of that, and restating it crowds out the part of the brief that
        only you can supply.
      '';
    };
    database-explorer = { };
    documenter = {
      note = ''
        Before delegating to `documenter`, check whether the task depends on facts gathered from an earlier subagent
        call in this same request (e.g. database structure from `database-explorer`, code details from
        `local-code-explorer`). If so, include those facts directly in the delegation -- they don't carry over
        automatically from one subagent call to the next. If the documentation task requires understanding code, schema,
        or system structure you don't already have, delegate that investigation first, then pass what you learned to
        `documenter` along with the writing task.

        Pass along what you learned, not documentation you wrote from it. A brief shaped like "replace the contents of
        this file with the following, keeping everything else identical" followed by finished text is a rewrite
        request, not a documentation request. Say what needs documenting and what you know about it -- "the
        documentation in this class is poor, replace it; the class is an internal container for engine exceptions" --
        and stop there. When `documenter` can read the subject itself, that is usually the entire brief.
      '';
    };
    editor = {
      note = ''
        Before delegating to `editor`, check whether the change depends on facts gathered from an earlier subagent call
        in this same request (e.g. code details from `local-code-explorer`). If so, include those facts directly in the
        delegation -- they don't carry over automatically from one subagent call to the next. If you do not yet know
        enough about the code to specify the change precisely, delegate that investigation first, then pass what you
        learned to `editor` along with the change to make.

        Documentation is never part of an `editor` brief. When a request covers both -- create this class and document
        it, change this function and update its docstring -- send `editor` only the code change, wait for its report,
        then delegate the documentation to `documenter` yourself, passing the file paths and what the new code is for.
        Do not hand `editor` a brief that includes documenting something and expect it to route that onward -- it will
        write the documentation itself.
      '';
    };
    image-interpreter = {
      note = ''
        An image attached directly to your own conversation cannot be forwarded -- delegation carries text only, and a
        filename read off an attachment usually arrives without its directory. You can see such an image yourself, so
        interpret it directly rather than delegating.
      '';
    };
    local-code-explorer = { };
    remote-code-explorer = { };
    researcher = { };
    tester = {
      note = ''
        When `tester` reports failures, send the fix to `editor` yourself, passing along what `tester` reported, since
        that report is the only record you get. Run again afterwards only if you need the result confirmed --
        re-delegating an unchanged run produces the same failures more slowly.

        Its reporting rules are its own. You do not need to tell it to give counts, to include skipped tests, or to
        collapse repetition; it already does all of that, and restating it crowds out the part of the brief that only
        you can supply.
      '';
    };
    web-explorer = { };
  };

  description = ''
    Primary orchestrating agent that delegates specialized work to subagents.
  '';

  mode = "primary";

  permission = {
    both = {
      "*" = "deny";
      "question" = "allow";
      "skill" = {
        "*" = "allow";
        "customize-opencode" = "deny";
        "global-*" = "deny";
      };
    };
  };
}
