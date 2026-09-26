{ lib, pkgs, ... }:
let
  extras = [
    "lazyvim.plugins.extras.coding.blink"
    "lazyvim.plugins.extras.editor.aerial"
    "lazyvim.plugins.extras.editor.neo-tree"
    "lazyvim.plugins.extras.lang.docker"
    "lazyvim.plugins.extras.lang.json"
    "lazyvim.plugins.extras.lang.markdown"
    "lazyvim.plugins.extras.lang.nix"
    "lazyvim.plugins.extras.lang.terraform"
    "lazyvim.plugins.extras.lang.typescript"
    "lazyvim.plugins.extras.lang.yaml"
    "lazyvim.plugins.extras.ui.edgy"
  ];

  lintPlugins = ''
    return {
      "mfussenegger/nvim-lint",
      opts = {
        linters = {
          ["markdownlint-cli2"] = {
            prepend_args = { "--config", "${markdownlintConfig}" },
          },
        },
      },
    }
  '';

  localPlugins = ''
    return {
      {
        "rafamadriz/friendly-snippets",
        dir = "${pkgs.vimPlugins.friendly-snippets}",
      },
      {
        "saghen/blink.cmp",
        dir = "${pkgs.vimPlugins.blink-cmp}",
      },
      {
        dir = "${pkgs.vimPlugins.mini-align}",
        event = "LazyFile",
        name = "mini.align",
        opts = {},
      },
      {
        dir = "${pkgs.vimPlugins.monokai-pro-nvim}",
        lazy = false,
        name = "monokai-pro.nvim",
        opts = { filter = "classic" },
        priority = 1000,
      },
      {
        dir = "${pkgs.vimPlugins.rainbow-delimiters-nvim}",
        event = "LazyFile",
        name = "rainbow-delimiters.nvim",
      },
      {
        dir = "${pkgs.vimPlugins.unicode-vim}",
        event = "VeryLazy",
        name = "unicode.vim",
      },
    }
  '';

  markdownlintConfig = pkgs.writeText ".markdownlint.yaml" ''
    MD013:
      code_block_line_length: 150
      heading_line_length: 150
      line_length: 150
    MD025: false
  '';
in
{
  home.activation.clearNeovimLuaCache = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    rm -rf "$HOME/.cache/nvim/luac"
  '';

  programs.lazyvim = {
    configFiles = ./lazyvim;
    enable = true;

    # Servers and tools the extras expect but do not install themselves.
    extraPackages = with pkgs; [
      bash-language-server
      lemminx
      marksman
      nil
      nixfmt
      statix
      terraform-ls
      tflint
      vscode-langservers-extracted
      vtsls
      yaml-language-server
    ];

    # coding.blink is a LazyVim default, but the module only packages extras that are enabled here.
    extras = {
      coding.blink.enable = true;
      editor.aerial.enable = true;
      editor.neo-tree.enable = true;
      lang = {
        docker = {
          enable = true;
          installDependencies = true;
        };
        json = {
          enable = true;
          installDependencies = true;
        };
        markdown = {
          enable = true;
          installDependencies = true;
        };
        nix.enable = true;
        terraform.enable = true;
        typescript.enable = true;
        yaml.enable = true;
      };
      ui.edgy.enable = true;
    };

    ignoreBuildNotifications = true;

    plugins = {
      lint = lintPlugins;
      local = localPlugins;
    };

    # Grammars beyond what the core set and the enabled extras provide.
    treesitterParsers = with pkgs.vimPlugins.nvim-treesitter-parsers; [
      cpp
      csv
      editorconfig
      http
      ini
      java
      javadoc
    ];
  };

  programs.neovim = {
    viAlias = true;
    vimAlias = true;
  };

  xdg.configFile."nvim/lazyvim.json".text = builtins.toJSON {
    inherit extras;
    install_version = 8;
    news = { };
    version = 8;
  };

  # The generated init.lua clones lazy.nvim from GitHub when this path is missing; provide it from nixpkgs instead. lazy.nvim only treats a real
  # directory under its root as installed, so link the package's files rather than the package itself.
  xdg.dataFile."nvim/lazy/lazy.nvim" = {
    force = true;
    recursive = true;
    source = pkgs.vimPlugins.lazy-nvim;
  };
}
