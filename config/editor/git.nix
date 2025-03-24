let
  inherit (builtins) toJSON;
in
{
  plugins = {
    gitsigns = {
      enable = true;

      lazyLoad.settings.event = "DeferredUIEnter";

      settings = {
        current_line_blame = true;

        current_line_blame_opts = {
          delay = 500;

          ignore_blank_lines = true;
          ignore_whitespace = true;
          virt_text = true;
          virt_text_pos = "eol";
        };

        signcolumn = false;
      };
    };

    which-key.settings.spec = [
      {
        __unkeyed = "<leader>gh";
        group = "Hunks";
        icon = " ";
      }
      {
        __unkeyed = "<leader>ug";
        group = "Git";
      }
    ];
  };

  keymaps = [
    # UI binds
    {
      mode = "n";
      key = "<leader>gb";
      action = "<CMD>Gitsigns toggle_current_line_blame<CR>";
      options = {
        desc = "Git Blame toggle";
      };
    }
    {
      mode = "n";
      key = "<leader>gd";
      action = "<CMD>Gitsigns toggle_deleted<CR>";
      options = {
        desc = "Deleted toggle";
      };
    }
    {
      mode = "n";
      key = "<leader>gl";
      action = "<CMD>Gitsigns toggle_linehl<CR>";
      options = {
        desc = "Line Highlight toggle";
      };
    }
    {
      mode = "n";
      key = "<leader>gn";
      action = "<CMD>Gitsigns toggle_numhl<CR>";
      options = {
        desc = "Number Highlight toggle";
      };
    }
    {
      mode = "n";
      key = "<leader>gw";
      action = "<CMD>Gitsigns toggle_word_diff<CR>";
      options = {
        desc = "Word Diff toggle";
      };
    }
    {
      mode = "n";
      key = "<leader>gst";
      action = "<CMD>Gitsigns toggle_signs<CR>";
      options = {
        desc = "Signs toggle";
      };
    }
    {
      mode = "n";
      key = "<leader>gbl";
      action.__raw = ''
        function() require("gitsigns").blame_line({ full=true }) end
      '';
      options = {
        desc = "Git Blame Line";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>gB";
      action.__raw = ''
        function() require("gitsigns").blame() end
      '';
      options = {
        desc = "Git Blame buffer";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>gD";
      action.__raw = ''
        function() require("gitsigns").diffthis() end
      '';
      options = {
        desc = "Diff this";
        silent = true;
      };
    }

    # Hunk binds
    {
      mode = "n";
      key = "<leader>ghp";
      action.__raw = ''
        function()
          if vim.wo.diff then return ${toJSON "<leader>gp"} end

          vim.schedule(function() require("gitsigns").prev_hunk() end)

          return '<Ignore>'
        end
      '';
      options = {
        desc = "Previous hunk";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>ghn";
      action.__raw = ''
        function()
          if vim.wo.diff then return ${toJSON "<leader>gn"} end

          vim.schedule(function() require("gitsigns").next_hunk() end)

          return '<Ignore>'
        end
      '';
      options = {
        desc = "Next hunk";
        silent = true;
      };
    }
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>ghs";
      action = "<CMD>Gitsigns stage_hunk<CR>";
      options = {
        desc = "Stage hunk";
      };
    }
    {
      mode = "n";
      key = "<leader>ghu";
      action = "<CMD>Gitsigns undo_stage_hunk<CR>";
      options = {
        desc = "Undo stage hunk";
      };
    }
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>ghr";
      action = "<CMD>Gitsigns reset_hunk<CR>";
      options = {
        desc = "Reset hunk";
      };
    }
    {
      mode = "n";
      key = "<leader>ghP";
      action = "<CMD>Gitsigns preview_hunk<CR>";
      options = {
        desc = "Preview hunk";
      };
    }
    {
      mode = "n";
      key = "<leader>ghp";
      action = "<CMD>Gitsigns preview_hunk_inline<CR>";
      options = {
        desc = "Preview hunk inline";
      };
    }

    # Buffer binds
    {
      mode = "n";
      key = "<leader>ghs";
      action = "<CMD>Gitsigns stage_buffer<CR>";
      options = {
        desc = "Stage buffer";
      };
    }
    {
      mode = "n";
      key = "<leader>ghr";
      action = "<CMD>Gitsigns reset_buffer<CR>";
      options = {
        desc = "Reset buffer";
      };
    }
  ];
}
