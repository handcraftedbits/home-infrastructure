{
  delegatesTo = { };

  delegation = {
    briefing = [
      ''
        Where the image is -- a URL, or a path under the working directory, which is the only filesystem
        `image-interpreter` shares with you. Referring to "the image above" never works: it starts a fresh session and
        sees only the text you send it.
      ''
      ''
        What you need out of the image, stated directly -- a description, an answer to a question, a transcription, a
        count, a comparison, particular fields extracted. Anything answerable by looking at the image is fair to ask
        for.
      ''
      ''
        What shape you want the answer in, if it matters -- JSON against a schema you supply, a table, a list, a target
        word count. It returns prose unless you ask for something else, and a short description if you name no depth.
      ''
      "What you'll do with the answer, if it changes what matters in the image."
    ];

    intro = ''
      Any time a task depends on what is actually in a picture, screenshot, diagram, or photo that you can reach by URL
      or by a path under the working directory, delegate it to the `image-interpreter` subagent rather than reasoning
      from the filename or from what the image is said to contain. Its scope is anything answerable by looking at the
      image, not a fixed set of question types -- describing, reading text off it, counting, comparing, pulling values
      out into a structure you define. Delegating also keeps the image itself out of your own context: only the answer
      comes back.
    '';

    outro = ''
      The `image-interpreter` returns what you asked for in the format you asked for, defaulting to prose, with any
      caveats about legibility, counting, or ambiguity noted at the end rather than mixed into the output. It reports
      only what is visibly there: it will not identify real people by name, guess at cropped or unreadable text, or
      describe an image it could not open. It reads and interprets only -- it cannot edit, generate, or move images.
    '';

    title = "Image Interpretation";
  };

  description = ''
    Looks at an image and reports back whatever you need from it -- a description at any depth, an answer to a specific
    question, a transcription, a count, a comparison, fields extracted into a format you specify. Accepts a path on disk
    or a URL. Use for "describe this image", "describe this in depth / in 500 words", "how many people are in this
    picture", "what does this screenshot say", "return the fields on this receipt as JSON". State where the image is,
    what you need from it, and what format you want it in; it defaults to a short prose description.
  '';

  mode = "subagent";

  permission = {
    both = {
      "*" = "deny";
      "read" = "allow";
      "webfetch" = "allow";
    };
  };
}
