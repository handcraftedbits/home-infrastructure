{ pkgs, ... }:
let
  tabstop2 = ''
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
  '';

  tabstop5 = ''
    vim.opt_local.tabstop = 5
    vim.opt_local.shiftwidth = 5
    vim.opt_local.softtabstop = 5
  '';
in
{
  # Additional required packages.
  home.packages = with pkgs; [
    bash-language-server
    dockerfile-language-server
    lemminx
    nil
    terraform-ls
    typescript-language-server
    vscode-langservers-extracted
    yaml-language-server
  ];

  programs.nixvim = {
    colorscheme = "molokai";

    diagnostic.settings = {
      signs = true;
      underline = true;
      update_in_insert = false;
      virtual_text = true;
    };

    enable = true;

    extraConfigLua = builtins.readFile ./config.lua;

    extraPlugins = with pkgs.vimPlugins; [
      molokai
      tabular
      unicode-vim
      vim-fugitive
    ];

    globals = {
      mapleader = ",";
      rehash256 = 1;
    };

    highlight = {
      ColorColumn.bg = "#2d2d2d";
    };

    impureRtp = false;

    keymaps = [
      {
        action = "<cmd>nohlsearch<CR>";
        key = "<leader><space>";
        mode = "n";
      }
      {
        action = "<cmd>NvimTreeToggle<CR>";
        key = "<leader>n";
        mode = "n";
      }
      {
        action = "<cmd>AerialToggle<CR>";
        key = "<leader>t";
        mode = "n";
      }
    ];

    opts = {
      encoding = "utf-8";
      expandtab = true;
      autoindent = true;
      backspace = "indent,eol,start";
      backup = false;
      colorcolumn = "120";
      completeopt = "menu,menuone,noselect";
      cursorline = true;
      fillchars = {
        vert = "│";
      };
      hlsearch = true;
      incsearch = true;
      list = true;
      listchars = {
        space = "·";
        tab = "→ ";
        nbsp = "␣";
      };
      lazyredraw = true;
      mouse = "a";
      showmatch = true;
      number = true;
      swapfile = false;
      termguicolors = true;
      undofile = false;
    };

    plugins = {
      aerial = {
        enable = true;
        settings = {
          attach_mode = "global";
          filter_kind = false;
          layout = {
            default_direction = "right";
            placement = "edge";
            resize_to_content = false;
            width = 60;
          };
          max_level = 10;
        };
      };

      cmp = {
        autoEnableSources = true;
        enable = true;
        settings = {
          mapping = {
            "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
            "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-e>" = "cmp.mapping.abort()";
          };
          sources = [
            { name = "buffer"; }
            { name = "luasnip"; }
            { name = "nvim_lsp"; }
            { name = "path"; }
          ];
          snippet = {
            expand = "function(args) require('luasnip').lsp_expand(args.body) end";
          };
        };
      };

      lsp = {
        enable = true;
        servers = {
          bashls.enable = true;
          dockerls = {
            enable = true;
            filetypes = [
              "containerfile"
              "dockerfile"
            ];
          };
          html.enable = true;
          jsonls.enable = true;
          lemminx.enable = true;
          nil_ls.enable = true;
          terraformls.enable = true;
          ts_ls.enable = true;
          yamlls.enable = true;
        };
      };

      lualine = {
        enable = true;

        settings = {
          options = {
            theme = {
              sections = {
                lualine_a = [ "mode" ];
                lualine_b = [ ];
                lualine_c = [ ];
                lualine_x = [
                  { __unkeyed-1 = "encoding"; }
                  { __unkeyed-1 = "fileformat"; }
                  { __unkeyed-1 = "filetype"; }
                ];
                lualine_y = [ "progress" ];
                lualine_z = [ "location" ];
              };
              inactive = {
                a = {
                  bg = "#465457";
                  fg = "#080808";
                };
                b = {
                  bg = "#465457";
                  fg = "#080808";
                };
                c = {
                  bg = "#465457";
                  fg = "#080808";
                };
              };
              insert = {
                a = {
                  bg = "#66D9E8";
                  fg = "#080808";
                  gui = "bold";
                };
              };
              normal = {
                a = {
                  bg = "#E6DB74";
                  fg = "#080808";
                  gui = "bold";
                };
                b = {
                  bg = "#232526";
                  fg = "#F8F8F0";
                };
                c = {
                  bg = "#465457";
                  fg = "#F8F8F0";
                };
              };
              replace = {
                a = {
                  bg = "#F92672";
                  fg = "#080808";
                  gui = "bold";
                };
              };
              visual = {
                a = {
                  bg = "#A6E22E";
                  fg = "#080808";
                  gui = "bold";
                };
              };
            };
          };
        };
      };

      nvim-tree = {
        enable = true;
        settings = {
          actions.open_file.window_picker.enable = false;
          filters.dotfiles = false;
          view = {
            preserve_window_proportions = true;
            width = 50;
          };
        };
      };

      rainbow-delimiters.enable = true;

      render-markdown = {
        enable = true;
        settings = {
          enabled = true;
          file_types = [ "markdown" ];
        };
      };

      telescope = {
        enable = true;
        keymaps = {
          "<leader>fb" = "buffers";
          "<leader>ff" = "find_files";
          "<leader>fg" = "live_grep";
          "<leader>fh" = "help_tags";
        };
      };

      treesitter = {
        enable = true;
        grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          bash
          c
          cpp
          csv
          dockerfile
          editorconfig
          html
          http
          ini
          java
          javadoc
          javascript
          json
          nix
          regex
          terraform
          typescript
          xml
          yaml
        ];
        settings = {
          highlight.enable = true;
        };
      };

      web-devicons.enable = true;
    };

    viAlias = true;
    vimAlias = true;
    wrapRc = true;
  };
}
