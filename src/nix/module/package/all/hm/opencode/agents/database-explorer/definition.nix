{
  delegatesTo = { };

  delegation = {
    briefing = [
      "Which table(s), and the database/schema they belong to if there's any ambiguity or more than one candidate."
      "Whether you need a structural overview or the actual DDL."
    ];

    intro = ''
      You do not have direct access to database inspection tools. Any time you need to know about database structure --
      what a table looks like, its columns/constraints/keys/indices, or its DDL -- delegate it to the
      `database-explorer` subagent rather than guessing at schema from code or memory.
    '';

    outro = ''
      The `database-explorer` will return a structured overview per table, or DDL when asked. It is read-only and cannot
      query data or make changes, so use it purely to inform decisions or documentation.
    '';

    title = "Database Exploration";
  };

  description = ''
    Inspects database structure using whatever database-access tools are available in the current session -- describes
    tables, columns, constraints, keys, and indices, or returns the DDL (CREATE statements) for one or more tables and
    associated entities. Use for "describe table X", "what's the schema of Y", "show me the DDL for Z", or any question
    about database structure.
  '';

  mode = "subagent";

  permission = {
    intellij = {
      "*" = "deny";
      "intellij_get_database_object_description" = "allow";
      "intellij_list_database_connections" = "allow";
      "intellij_list_database_schemas" = "allow";
      "intellij_list_schema_object_kinds" = "allow";
      "intellij_list_schema_objects" = "allow";
    };
  };

  profiles = [ "intellij" ];
}
