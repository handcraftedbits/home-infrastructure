{
  delegatesTo = {
    database-explorer = { };
    documenter = {
      note = ''
        Before delegating to `documenter`, check whether the task depends on facts gathered from an earlier subagent
        call in this same request (e.g. database structure from `database-explorer`, code details from
        `local-code-explorer`). If so, include those facts directly in the delegation -- they don't carry over
        automatically from one subagent call to the next. If the documentation task requires understanding code, schema,
        or system structure you don't already have, delegate that investigation first, then pass what you learned to
        `documenter` along with the writing task.
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
    };
  };
}
