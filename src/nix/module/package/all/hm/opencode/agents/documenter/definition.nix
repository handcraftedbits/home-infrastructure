{
  delegatesTo = { };

  delegation = {
    briefing = [
      "What is being documented -- a class, a module, a schema, a system, a release history -- and where it lives."
      "What it is and what it does: behavior, purpose, structure, how it relates to what surrounds it."
      "Anything not recoverable from the subject itself -- intent, history, gotchas, why an approach was chosen."
      "Where the documentation should go, if it is a standalone artifact rather than documentation in place."
    ];

    intro = ''
      Documentation is `documenter`'s to write, not yours. Any time a task involves writing or updating
      documentation -- READMEs, API docs, docstrings, changelogs, architecture notes, schema/system documentation --
      delegate it to the `documenter` subagent.

      Give `documenter` the material, not the wording. Describe the subject -- what it is, what it does, why it
      exists, and anything that cannot be recovered by inspecting it -- then let `documenter` decide what to say, how
      to say it, and which parts warrant saying anything about. Handing over finished sentences turns the job into
      transcription, and the conventions it would otherwise apply never get consulted. Do not enumerate the parts to
      cover as a way of setting scope either -- name the subject, supply the context, and leave coverage to
      `documenter`.

      Being specific and dictating the output are different things. `documenter` does not investigate on its own, so a
      vague task will come back as a question -- be precise about what is being documented, and generous with facts
      about it. It can read files, so you need not paste the contents of anything on disk; but facts it cannot reach
      that way, such as a live schema or a decision made elsewhere, have to come from you.
    '';

    outro = ''
      If `documenter` reports back that part or all of a request was excluded due to a skill constraint, relay that
      outcome and reason to the user rather than re-delegating with stronger phrasing to try to force compliance. This
      holds even when the result is that nothing at all was written -- an empty result with a stated reason is a
      finished task, not a failed one.

      Only re-delegate if the user, after hearing the outcome, explicitly authorizes going beyond the constraint. In
      that case, pass along the user's own words for what they want documented; do not synthesize the authorization
      yourself out of the exclusion reasons `documenter` reported. You do not know what phrasing a skill treats as an
      override, and guessing at it in order to get a different result is exactly the behavior this rule forbids.

      The `documenter` will report back what it wrote or changed.
    '';

    title = "Documentation";
  };

  description = ''
    Handles software documentation tasks across three areas: written docs (READMEs, API/reference docs, changelogs,
    architecture notes), source code documentation (docstrings, inline comments), and system documentation (database
    schemas, data flows, service/component architecture). Works from information supplied by the caller rather than
    exploring the codebase itself.
  '';

  mode = "subagent";

  permission = {
    both = {
      "*" = "deny";
      "skill" = {
        "*" = "deny";
        "global-write-javadoc" = "allow";
        "global-write-mermaid-erd" = "allow";
      };
    };

    default = {
      "edit" = "allow";
      "glob" = "allow";
      "grep" = "allow";
      "read" = "allow";
    };

    intellij = {
      "agentbridge_edit_text" = "allow";
      "agentbridge_find_file" = "allow";
      "agentbridge_insert_*" = "allow";
      "agentbridge_list_directory_tree" = "allow";
      "agentbridge_read_file" = "allow";
      "agentbridge_search_*" = "allow";
      "agentbridge_write_file" = "allow";
    };
  };
}
