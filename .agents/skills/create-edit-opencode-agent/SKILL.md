---
name: create-edit-opencode-agent
description: >
  Creating, editing, or removing an OpenCode subagent in this repository, and changing which agents may delegate to
  which. Use this skill whenever the user asks to add a new OpenCode agent or subagent, change what an existing one
  does, adjust its tool permissions, wire up or remove a delegation edge ("let the code-explorer call the researcher",
  "stop X from delegating to Y"), or restrict an agent to a particular launch mode. Triggers on mentions of
  `definition.nix`, `prompt.md`, `delegatesTo`, the agent capability graph, or any path under
  `src/nix/module/package/all/hm/opencode/agents/`.
---

# OpenCode Agent Authoring Skill

OpenCode agents in this repository are not hand-written Markdown. Each agent is a **directory of two files**, and the
agent Markdown that OpenCode actually consumes is *generated* from them by a Nix capability graph. Editing generated
output directly is always wrong -- it is overwritten on the next rebuild.

## Layout

```
src/nix/module/package/all/hm/opencode/agents/
  default.nix              <- the graph engine; do not edit for routine agent changes
  <agent-name>/
    definition.nix         <- metadata, permissions, delegation edges
    prompt.md              <- the agent's system prompt body
```

Agents are discovered with `readDir`. Creating the directory **is** the registration step -- there is no list to add
the agent to.

The engine renders, per launch profile, a store directory of `<agent-name>.md` files (frontmatter + prompt body +
generated delegation sections) plus the `agent.<name>` block of `opencode.json`.

## The One Concept That Governs Everything

Delegation prose is owned by the **callee**, not the caller.

An agent's `delegation` attribute describes how *other* agents should brief it and what it returns. A caller declares
only an edge in `delegatesTo`. The engine then renders that callee's `delegation` block into the caller's prompt.

This means: when adding an edge, you almost never write new prose. If `code-explorer` gains an edge to `researcher`,
`code-explorer`'s prompt automatically grows the same researcher briefing that `main` already has. Copying delegation
instructions between agents by hand defeats the entire design -- if you find yourself doing that, the text belongs in
the target's `delegation` instead.

## Required Information

Before writing anything, you need the following. Ask the user for whatever is missing rather than inventing it -- a
guessed permission set or a guessed delegation edge is worse than a question.

| Information                | Needed when                  | If missing                                                   |
|----------------------------|------------------------------|--------------------------------------------------------------|
| Agent name (kebab-case)    | Creating                     | Ask; it becomes the directory name and the opencode agent id |
| What the agent does        | Creating                     | Ask                                                          |
| `subagent` or `primary`    | Creating                     | Assume `subagent` unless it is user-facing; confirm          |
| Which tools it may use     | Creating, or changing access | Ask -- never guess a permission set                          |
| Who may delegate **to** it | Creating                     | Ask; an agent nothing can reach is dead code                 |
| Who it may delegate **to** | Creating                     | Assume none unless stated                                    |
| Launch profiles            | Creating                     | Assume both unless its tooling is IntelliJ-only              |

If the user describes an agent's job but not its tools, ask specifically: permissions are deny-by-default, so an agent
with an unspecified permission set can do nothing at all.

## definition.nix Reference

Attribute keys are sorted **alphabetically**, matching the rest of this repository. So are `let` bindings and
permission keys (`"*"` sorts first naturally).

`model`, `temperature`, `top_k`, and `top_p` are tuning attributes: each reaches the generated config only if the
definition sets it. An unset one is left out rather than pinned, so it falls through to OpenCode's own default -- or,
for `model`, to the global model in `config/opencode.json`.

| Attribute      | Required                               | Notes                                                |
|----------------|----------------------------------------|------------------------------------------------------|
| `delegatesTo`  | Yes (`{ }` if it delegates to nothing) | Outgoing edges; keys are agent names                 |
| `delegation`   | Only if something delegates to it      | Omit entirely for a primary agent                    |
| `description`  | Yes                                    | Becomes frontmatter and the Task tool's description  |
| `mode`         | Yes                                    | `"primary"` or `"subagent"`                          |
| `model`        | No                                     | Omitted from the config entirely when unset          |
| `permission`   | Yes                                    | Keyed by scope, deny-by-default; see below           |
| `profiles`     | No                                     | Defaults to every profile                            |
| `temperature`  | No                                     | Omitted from the config entirely when unset          |
| `top_k`        | No                                     | Omitted from the config entirely when unset          |
| `top_p`        | No                                     | Omitted from the config entirely when unset          |

### delegation

Rendered into the prompt of every agent that declares an edge to this one.

| Field      | Required | Renders as                                                              |
|------------|----------|-------------------------------------------------------------------------|
| `title`    | Yes      | The `##` section heading in the caller's prompt                         |
| `intro`    | Yes      | Opening prose; must name the agent in backticks                         |
| `briefing` | No       | Bullets under "When delegating to `<name>`, be explicit about:"         |
| `outro`    | No       | Closing prose -- typically what the agent returns and what it cannot do |

Write `intro` and `outro` addressed to the **caller** in second person ("You do not have direct access to ... delegate
it to `x`"), never to the agent itself. Keep them caller-agnostic: anything true only for one particular caller belongs
in that caller's per-edge `note`.

### delegatesTo

```nix
delegatesTo = {
  code-explorer = { };
  documenter = {
    note = ''
      Caller-specific guidance appended to the end of documenter's section.
    '';
  };
};
```

Use a bare `{ }` unless the edge genuinely needs caller-specific guidance.

### permission

Keyed by scope, then by OpenCode permission pattern. Deny-by-default:

```nix
permission = {
  both = {
    "*" = "deny";
    "question" = "allow";
  };

  default = {
    "glob" = "allow";
    "grep" = "allow";
    "read" = "allow";
  };

  intellij = {
    "intellij_read_file" = "allow";
    "intellij_search_*" = "allow";
  };
};
```

| Scope       | Applies to                                                          |
|-------------|---------------------------------------------------------------------|
| `both`      | Every profile -- the shared baseline, and where `"*" = "deny"` goes |
| `default`   | The `opencode` launcher only                                        |
| `intellij`  | The `opencode-intellij` launcher only                               |

A profile scope is merged over `both`, so a profile-specific key of the same name wins. This is where the same
capability is spelled differently per launcher: `read`/`grep` in default versus `intellij_read_file`/`intellij_search_*`
in IntelliJ. An agent narrowed by `profiles` may only use scopes it actually exists in -- an intellij-only agent puts
everything under `intellij` and needs no `both`.

Do **not** put per-agent permissions in `config/patch-default.json` or `config/patch-intellij.json`. Those now carry
only profile config that isn't per-agent (currently just the IntelliJ MCP server), and either may be absent entirely.

**Never set `task` by hand, in any scope.** It is derived from `delegatesTo`: an agent with no edges gets `"deny"`, one
with edges gets `{ "*" = "deny"; <each target> = "allow"; }`. Writing it manually creates exactly the drift this design
exists to prevent.

Rules are last-match-wins and JSON serialises keys in sorted order, so `"*"` (0x2A) lands ahead of the agent names. Do
not reorder to "fix" readability.

### profiles

`[ "default" "intellij" ]` -- the two launch modes (`opencode` and `opencode-intellij`). Omit the attribute to exist in
both. Narrow it only when the agent's tooling genuinely does not exist in a mode:

```nix
profiles = [ "intellij" ];
```

In a profile where an agent is unavailable, the engine emits `{"disable": true}`, skips its markdown file entirely, and
drops it from every other agent's delegation sections and task permissions. Do **not** additionally add a `disable`
entry to a patch file -- that is the old mechanism and duplicating it is redundant.

Note the distinction from `permission` scopes: `profiles` controls whether the agent *exists*, `permission` scopes
control what it can *do* where it exists. An agent available in both profiles but with different tooling in each needs
`permission.default` and `permission.intellij`, not a narrowed `profiles`.

## prompt.md Rules

The prompt body, and nothing else:

* **No YAML frontmatter.** The engine generates it from `description`.
* **No delegation sections.** They are generated from `delegatesTo`. A hand-written one will be duplicated.
* Written in second person to the agent itself ("You are a read-only ... subagent").
* `#` headings for top-level sections -- generated delegation content uses `#` / `##` and must not collide.
* Wrap at 120 columns; use `--` rather than an em dash; `*` for bullets.
* No trailing newline concerns -- the engine trims and re-joins blocks.

## Step-by-Step Instructions

### 1. Gather and Confirm

Collect the table above. Ask about anything missing. For an **edit**, read the existing `definition.nix` and `prompt.md`
first -- do not rewrite an agent from the user's description alone.

### 2. Write prompt.md

Body only, per the rules above. Match the voice of the sibling agents.

### 3. Write definition.nix

Alphabetical keys. Include `delegation` if anything will delegate to this agent; omit it for a primary agent.

### 4. Wire the Edges

Add the new agent to the `delegatesTo` of every agent that should reach it -- most commonly `main`. **Creating an agent
does not make it reachable.** An agent absent from every `delegatesTo` is unreachable and will make no difference to
anything.

### 5. Scope the Permissions

Put shared entries under `permission.both` and per-launcher tooling under `permission.default` / `permission.intellij`.
An agent that does real work in both launchers usually needs all three scopes, since IntelliJ exposes its own
`intellij_*` equivalents of the plain file and search tools.

Base `config/opencode.json` holds only OpenCode's built-in agent disables and the provider/model config -- do not add
per-agent blocks there or in the patch files.

### 6. Verify the Graph

The engine throws on: an edge to an unknown agent, a self-edge, a delegation cycle, an unknown profile name, and a
`permission` scope naming a profile the agent is unavailable in. Cycles are rejected deliberately -- two agents that
can delegate to each other can recurse without bound.

Do not run `nix build`, `nix eval`, or a rebuild yourself. Report what changed and let the user build.

### 7. Report

State which agents' *generated* prompts will change. Adding a `delegation` field or editing one silently rewrites a
section in every caller's prompt -- the user needs to know that a change to `researcher` altered `main` and
`code-explorer`.

## Removing an Agent

1. Delete the directory.
2. Remove it from every `delegatesTo` that names it -- otherwise the graph throws on an unknown target.

Nothing outside the agent's own directory holds per-agent config, so there is no third place to clean up.

## Checklist

* `prompt.md` has no frontmatter and no hand-written delegation section.
* `permission` is keyed by scope (`both` / `default` / `intellij`), not by pattern at the top level.
* `task` is not set by hand in any scope.
* `delegation` prose addresses the caller, and is free of caller-specific detail.
* Caller-specific detail lives in a per-edge `note`.
* The agent appears in at least one other agent's `delegatesTo`.
* Attribute keys are alphabetical.
* No `disable` entry was added for an agent already narrowed by `profiles`.
