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

  temperature = 1.0;
  top_k = 64;
  top_p = 0.95;
}
