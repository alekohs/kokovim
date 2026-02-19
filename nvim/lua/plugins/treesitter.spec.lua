return {
  -- Main treesitter plugin
  kokovim.get_plugin_by_repo("nvim-treesitter/nvim-treesitter", {
    branch = "main",
    lazy = false, -- Load immediately to set up autocmds
    build = not kokovim.is_nix and ":TSUpdate" or nil,
    dependencies = {
      kokovim.get_plugin_by_repo("windwp/nvim-ts-autotag", {
        opts = {
          opts = {
            enable_close_on_slash = true,
          },
        },
      }),
    },
    opts = {
      install_dir = vim.fn.stdpath("data") .. "/site",
    },
    config = function(_, opts)
      -- Set treesitter grammars and install_dir to runtimepath if running with nix
      -- This must happen here (not at module level) because lazy.nvim resets the rtp
      if kokovim.is_nix then
        local plugins_folder = require("kokovim.plugin").get_plugin_folder()
        vim.opt.runtimepath:append(plugins_folder .. "nvim-treesitter-grammars")
        -- Main branch stores queries under runtime/ which Neovim doesn't search by default
        vim.opt.runtimepath:append(plugins_folder .. "nvim-treesitter/runtime")
        vim.opt.runtimepath:append(opts.install_dir)
      end

      -- Setup nvim-treesitter with the new API
      require("nvim-treesitter").setup(opts)

      -- Enable treesitter highlighting automatically for all filetypes (except disabled ones)
      -- The main branch requires manual activation via vim.treesitter.start()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "*",
        callback = function(args)
          local filetype = vim.api.nvim_get_option_value("filetype", { buf = args.buf })

          local lang = vim.treesitter.language.get_lang(filetype) or filetype
          if require("nvim-treesitter.parsers")[lang] == nil then return end

          local has_parser = pcall(vim.treesitter.language.inspect, lang)
          if not has_parser and not kokovim.is_nix then
            require("nvim-treesitter").install({ lang }):wait(300000)
            pcall(vim.treesitter.start, args.buf)
          elseif has_parser then
            pcall(vim.treesitter.start, args.buf)
          end
        end,
      })
    end,
  }),

  -- Treesitter context (sticky function headers)
  kokovim.get_plugin_by_repo("nvim-treesitter/nvim-treesitter-context", {
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      kokovim.get_plugin_by_repo("nvim-treesitter/nvim-treesitter"),
    },
    opts = { mode = "cursor", max_lines = 3 },
    config = function(_, opts)
      local tsc = require("treesitter-context")
      tsc.setup(opts)
      vim.keymap.set("n", "<leader>ut", function() tsc.toggle() end, { desc = "Toggle treesitter context" })
    end,
  }),

  -- Treesitter textobjects
  kokovim.get_plugin_by_repo("nvim-treesitter/nvim-treesitter-textobjects", {
    branch = "main",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      kokovim.get_plugin_by_repo("nvim-treesitter/nvim-treesitter"),
    },
    config = function()
      -- Setup textobjects with the new API
      require("nvim-treesitter-textobjects").setup({
        select = {
          lookahead = true,
        },
        move = {
          set_jumps = true,
        },
      })

      -- Select keymaps
      vim.keymap.set(
        { "x", "o" },
        "af",
        function() require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects") end,
        { desc = "Select outer function" }
      )

      vim.keymap.set(
        { "x", "o" },
        "if",
        function() require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects") end,
        { desc = "Select inner function" }
      )

      vim.keymap.set(
        { "x", "o" },
        "ac",
        function() require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects") end,
        { desc = "Select outer class" }
      )

      vim.keymap.set(
        { "x", "o" },
        "ic",
        function() require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects") end,
        { desc = "Select inner class" }
      )

      -- Move keymaps - next start
      vim.keymap.set(
        { "n", "x", "o" },
        "]m",
        function() require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects") end,
        { desc = "Next function start" }
      )

      vim.keymap.set(
        { "n", "x", "o" },
        "]]",
        function() require("nvim-treesitter-textobjects.move").goto_next_start("@class.outer", "textobjects") end,
        { desc = "Next class start" }
      )

      vim.keymap.set(
        { "n", "x", "o" },
        "]d",
        function() require("nvim-treesitter-textobjects.move").goto_next_start("@conditional.outer", "textobjects") end,
        { desc = "Next conditional start" }
      )

      -- Move keymaps - next end
      vim.keymap.set(
        { "n", "x", "o" },
        "]M",
        function() require("nvim-treesitter-textobjects.move").goto_next_end("@function.outer", "textobjects") end,
        { desc = "Next function end" }
      )

      vim.keymap.set(
        { "n", "x", "o" },
        "][",
        function() require("nvim-treesitter-textobjects.move").goto_next_end("@class.outer", "textobjects") end,
        { desc = "Next class end" }
      )

      -- Move keymaps - previous start
      vim.keymap.set(
        { "n", "x", "o" },
        "[f",
        function() require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects") end,
        { desc = "Previous function start" }
      )

      vim.keymap.set(
        { "n", "x", "o" },
        "[[",
        function() require("nvim-treesitter-textobjects.move").goto_previous_start("@class.outer", "textobjects") end,
        { desc = "Previous class start" }
      )

      vim.keymap.set(
        { "n", "x", "o" },
        "[d",
        function() require("nvim-treesitter-textobjects.move").goto_previous_start("@conditional.outer", "textobjects") end,
        { desc = "Previous conditional start" }
      )

      -- Move keymaps - previous end
      vim.keymap.set(
        { "n", "x", "o" },
        "[F",
        function() require("nvim-treesitter-textobjects.move").goto_previous_end("@function.outer", "textobjects") end,
        { desc = "Previous function end" }
      )

      vim.keymap.set(
        { "n", "x", "o" },
        "[]",
        function() require("nvim-treesitter-textobjects.move").goto_previous_end("@class.outer", "textobjects") end,
        { desc = "Previous class end" }
      )
    end,
  }),
}
