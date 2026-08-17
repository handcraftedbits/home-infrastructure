{ lib, pkgs }:
let
  agentNames = lib.attrNames
    (lib.filterAttrs (_: type: type == "directory") (builtins.readDir ./.));

  agents = lib.genAttrs agentNames (name: import (./. + "/${name}/definition.nix"));

  # An agent with no `profiles` of its own exists in every profile.
  availableIn = profile: name: lib.elem profile (agents.${name}.profiles or profiles);

  check = lib.throwIf (errors != [ ])
    "opencode agent graph is invalid: ${lib.concatStringsSep "; " errors}";

  defaultModel = (builtins.fromJSON (builtins.readFile ../config/opencode.json)).model;

  # Edges to agents that don't exist in this profile are dropped, so neither the rendered prompt nor the task permission
  # can reference a disabled agent.
  edgesOf = profile: name: lib.filter (availableIn profile) (outgoing name);

  # Validated against the whole graph rather than per profile: a bad edge is a mistake even if some profile happens to
  # filter it out.
  errors =
    lib.concatMap
      (name: map (target: "${name} delegates to unknown agent ${target}")
        (lib.filter (target: !(agents ? ${target})) (outgoing name)))
      agentNames
    ++ map (name: "${name} delegates to itself")
      (lib.filter (name: lib.elem name (outgoing name)) agentNames)
    ++ map (name: "${name} is part of a delegation cycle")
      (lib.filter (name: lib.elem name reachable.${name}) agentNames)
    ++ map (name: "${name} declares unknown profiles")
      (lib.filter (name: !(lib.all (p: lib.elem p profiles) (agents.${name}.profiles or profiles)))
        agentNames)
    ++ map (name: "${name} scopes permission to a profile it is unavailable in, or to an unknown scope")
      (lib.filter
        (name: !(lib.all (scope: scope == "both" || availableIn scope name)
          (lib.attrNames agents.${name}.permission)))
        agentNames)
    ++ map (name: "${name} declares unknown model ${modelFor name}")
      (lib.filter (name: !(modelTuning ? ${modelFor name})) agentNames);

  frontmatter = description: ''
    ---
    description: |
    ${indent "  " description}
    ---
  '';

  indent = prefix: text: lib.concatMapStringsSep "\n"
    (line: if line == "" then "" else prefix + line)
    (lib.splitString "\n" (trim text));

  modelFor = name: agents.${name}.model or defaultModel;

  # Sampling parameters are a property of the model rather than the agent, so an agent declares only which model it
  # runs on and picks up the matching tuning from here.
  modelTuning = {
    "llm/chat" = {
      temperature = 1.0;
      top_k = 64;
      top_p = 0.95;
    };
    "llm/task" = {
      temperature = 1.0;
      top_k = 64;
      top_p = 0.95;
    };
  };

  outgoing = name: lib.attrNames (agents.${name}.delegatesTo or { });

  paragraphs = lib.concatStringsSep "\n\n";

  # `both` is the shared baseline; a profile-scoped key overrides it for that profile only. `task` is always derived
  # from the graph and cannot be set by hand.
  permissionFor = profile: name:
    let permission = agents.${name}.permission; in
    (permission.both or { })
    // (permission.${profile} or { })
    // { task = taskPermission profile name; };

  profiles = [ "default" "intellij" ];

  # Transitive closure by iteration; agentNames rounds is more than enough to saturate.
  reachable =
    let
      step = acc: lib.mapAttrs
        (_: reached: lib.unique (reached ++ lib.concatMap (t: acc.${t} or [ ]) reached))
        acc;
      iterate = n: acc: if n == 0 then acc else iterate (n - 1) (step acc);
    in
    iterate (lib.length agentNames) (lib.genAttrs agentNames outgoing);

  renderAgent = profile: name:
    frontmatter agents.${name}.description
    + "\n"
    + paragraphs ([ (trim (builtins.readFile (./. + "/${name}/prompt.md"))) ]
      ++ lib.optional (edgesOf profile name != [ ]) (renderDelegation profile name))
    + "\n";

  renderDelegation = profile: caller: paragraphs ([
    "# Delegation"
    (trim ''
      The subagents below are the ones you can reach with the `task` tool. Delegate to them rather than
      attempting their work yourself; anything not listed here is unavailable to you.
    '')
  ] ++ map (renderSection caller) (edgesOf profile caller));

  # Continuation lines of a bullet get hanging-indented to line up under the text.
  renderPoint = point: "* " + lib.removePrefix "  " (indent "  " point);

  # A section is rendered from the *target's* self-description, so every caller that declares the edge gets the same
  # briefing without duplicating it.
  renderSection = caller: target:
    let
      delegation = agents.${target}.delegation;
      edge = agents.${caller}.delegatesTo.${target};
    in
    paragraphs ([
      "## ${delegation.title}"
      (trim delegation.intro)
    ]
    ++ lib.optionals (delegation ? briefing) [
      "When delegating to `${target}`, be explicit about:"
      (lib.concatMapStringsSep "\n" renderPoint delegation.briefing)
    ]
    ++ lib.optionals (delegation ? outro) [ (trim delegation.outro) ]
    ++ lib.optionals (edge ? note) [ (trim edge.note) ]);

  # Rules are last-match-wins, so `*` must serialise ahead of the agent names -- builtins.toJSON emits keys in sorted
  # order and `*` sorts before [a-z-].
  taskPermission = profile: name:
    let targets = edgesOf profile name; in
    if targets == [ ] then "deny"
    else { "*" = "deny"; } // lib.genAttrs targets (_: "allow");

  trim = text: lib.removeSuffix "\n" text;

  # `model` is emitted only when the agent overrides the default; otherwise the config's top-level `model` applies.
  tuningFor = name:
    modelTuning.${modelFor name}
    // lib.optionalAttrs (agents.${name} ? model) { inherit (agents.${name}) model; };
in
check (lib.genAttrs profiles (profile: {
  directory = pkgs.runCommand "opencode-agents-${profile}" { } (''
    mkdir -p "$out"
  '' + lib.concatStrings (map
    (name: ''
      cp ${pkgs.writeText "${name}.md" (renderAgent profile name)} "$out/${name}.md"
    '')
    (lib.filter (availableIn profile) agentNames)));

  settings = lib.mapAttrs
    (name: agent:
      if availableIn profile name then {
        inherit (agent) mode;
        permission = permissionFor profile name;
      } // tuningFor name
      else {
        disable = true;
      })
    agents;
}))
