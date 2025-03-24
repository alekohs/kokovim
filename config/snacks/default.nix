{
  self,
  system,
  ...
}:
{
  imports = [
    ./explorer.nix
    ./dashboard.nix
    ./input.nix
    ./git.nix
    ./toggle.nix
    ./notifier.nix
  ];

  plugins.fzf-lua.lazyLoad = {
    enable = true;
    settings = {
      cmd = "FzfLua";
    };
  };

  plugins.snacks = {
    enable = true;
    #package = self.packages.${system}.snacks-nvim;
    #lazyLoad.enable = true;
    #lazyLoad.settings.event = "DeferredUIEnter";
    settings = {

      indent.enabled = true;
      scroll.enabled = false;
      image.enabled = false;

      statuscolumn = {
        enabled = true;
        folds = {
          open = true;
          git_hl = true;
        };
      };

      bigfile = {
        enabled = true;
        notify = true;
      };

      picker = {
        enabled = true;
        ui_select = true;
        layouts = {
          select = {
            relative = "cursor";
            width = 70;
            min_width = 0;
            row = 1;
          };
        };
      };
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>fa";
      action = ''<CMD>lua Snacks.picker.autocmds()<CR>'';
      options = {
        desc = "Find autocmds";
      };
    }
    {
      mode = "n";
      key = "<leader>fc";
      action = ''<CMD>lua Snacks.picker.commands()<CR>'';
      options = {
        desc = "Find commands";
      };
    }
    {
      mode = "n";
      key = "<leader>fC";
      action.__raw = ''
        function()
          require("snacks.picker").files {
            prompt_title = "Config Files",
            cwd = vim.fn.stdpath("config"),
          }
        end
      '';
      options = {
        desc = "Find config files";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>fd";
      action = ''<CMD>lua Snacks.picker.diagnostics_buffer()<CR>'';
      options = {
        desc = "Find buffer diagnostics";
      };
    }
    {
      mode = "n";
      key = "<leader>fD";
      action = ''<CMD>lua Snacks.picker.diagnostics()<CR>'';
      options = {
        desc = "Find workspace diagnostics";
      };
    }

    {
      mode = "n";
      key = "<leader>fh";
      action = ''<CMD>lua Snacks.picker.help()<CR>'';
      options = {
        desc = "Find help tags";
      };
    }
    # NOTE: prefer the UI but is lot slower
    {
      mode = "n";
      key = "<leader>fk";
      action = ''<CMD>lua Snacks.picker.keymaps()<CR>'';
      options = {
        desc = "Find keymaps";
      };
    }
    {
      mode = "n";
      key = "<leader>fO";
      action = ''<CMD>lua Snacks.picker.smart()<CR>'';
      options = {
        desc = "Find Smart (Frecency)";
      };
    }
    {
      mode = "n";
      key = "<leader>fp";
      action = ''<CMD>lua Snacks.picker.projects()<CR>'';
      options = {
        desc = "Find projects";
      };
    }
    {
      mode = "n";
      key = "<leader>fr";
      action = ''<CMD>lua Snacks.picker.registers()<CR>'';
      options = {
        desc = "Find registers";
      };
    }
    {
      mode = "n";
      key = "<leader>fs";
      action = ''<CMD>lua Snacks.picker.lsp_symbols()<CR>'';
      options = {
        desc = "Find lsp document symbols";
      };
    }
    {
      mode = "n";
      key = "<leader>fS";
      action = ''<CMD>lua Snacks.picker.spelling({layout = { preset = "select" }})<CR>'';
      options = {
        desc = "Find spelling suggestions";
      };
    }
    # Moved to todo-comments module since lazy loading wasn't working
    # {
    #   mode = "n";
    #   key = "<leader>ft";
    #   action = ''<CMD>lua Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" }})<CR>'';
    #   options = {
    #     desc = "Find TODOs";
    #   };
    # }
    {
      mode = "n";
      key = "<leader>fT";
      action = ''<CMD>lua Snacks.picker.colorschemes()<CR>'';
      options = {
        desc = "Find theme";
      };
    }
    {
      mode = "n";
      key = "<leader>f?";
      action = ''<CMD>lua Snacks.picker.grep_buffers()<CR>'';
      options = {
        desc = "Fuzzy find in open buffers";
      };
    }
    {
      mode = "n";
      key = "<leader>fu";
      action = "<CMD>lua Snacks.picker.undo()<CR>";
      options = {
        desc = "Undo History";
      };
    }
    # Profiler
    {
      mode = "n";
      key = "<leader>X";
      action = ''<CMD>lua Snacks.profiler.toggle()<CR>'';
      options = {
        desc = "Toggle Neovim profiler";
      };
    }
    {
      mode = "n";
      key = "<leader>f'";
      action = ''<CMD>lua Snacks.picker.marks()<CR>'';
      options = {
        desc = "Find marks";
      };
    }
    {
      mode = "n";
      key = "<leader>f/";
      action = ''<CMD>lua Snacks.picker.lines()<CR>'';
      options = {
        desc = "Fuzzy find in current buffer";
      };
    }
    {
      mode = "n";
      key = "<leader>f<CR>";
      action = ''<CMD>lua Snacks.picker.resume()<CR>'';
      options = {
        desc = "Resume find";
      };
    }
    {
      mode = "n";
      key = "<leader>fb";
      action = ''<CMD>lua Snacks.picker.buffers()<CR>'';
      options = {
        desc = "Find buffers";
      };
    }
    {
      mode = "n";
      key = "<leader><space>";
      action = ''<CMD>lua Snacks.picker.files()<CR>'';
      options = {
        desc = "Find files";
      };
    }
    {
      mode = "n";
      key = "<leader>fl";
      action = ''<CMD>lua Snacks.picker.man()<CR>'';
      options = {
        desc = "Find man pages";
      };
    }
    {
      mode = "n";
      key = "<leader>fo";
      action = ''<CMD>lua Snacks.picker.recent()<CR>'';
      options = {
        desc = "Find old files";
      };
    }
    {
      mode = "n";
      key = "<leader>fq";
      action = ''<CMD>lua Snacks.picker.qflist()<CR>'';
      options = {
        desc = "Find quickfix";
      };
    }
    {
      mode = "n";
      key = "<leader>/";
      action = "<CMD>lua Snacks.picker.grep()<CR>";
      options = {
        desc = "Live grep";
      };
    }
    {
      mode = "n";
      key = "<leader>gs";
      action = ''<CMD>lua Snacks.picker.git_status()<CR>'';
      options = {
        desc = "Find git status";
      };
    }
    # {
    #   mode = "n";
    #   key = "<leader>gS";
    #   action = ''<CMD>lua Snacks.picker.git_stash()<CR>'';
    #   options = {
    #     desc = "Find git stashes";
    #   };
    # }
    {
      mode = "n";
      key = "<leader>fe";
      action = ''<CMD>lua Snacks.explorer.open() cr>'';
      options = {
        desc = "Open snacks tree";
      };
    }

  ];

}
