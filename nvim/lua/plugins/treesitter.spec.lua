local disabled_files = {
  "Enums.hs",
  "all-packages.nix",
  "hackage-packages.nix",
  "generated.nix",
}

local disabled_filetypes = {
  "tmux",
}

local function should_disable_treesitter(bufnr)
  local filetype = vim.api.nvim_get_option_value("filetype", { buf = bufnr })
  local fname = vim.api.nvim_buf_get_name(bufnr)
  local short_name = vim.fn.fnamemodify(fname, ":t")
  return vim.tbl_contains(disabled_files, short_name) or vim.tbl_contains(disabled_filetypes, filetype)
end

-- Parsers to install (only used when not running with nix)
local parsers = {
  "arduino",
  "angular",
  "bash",
  "c",
  "c_sharp",
  "css",
  "diff",
  "fish",
  "git_config",
  "git_rebase",
  "gitcommit",
  "gitattributes",
  "gitignore",
  "go",
  "html",
  "http",
  "javascript",
  "jsdoc",
  "json",
  "lua",
  "luadoc",
  "make",
  "markdown",
  "markdown_inline",
  "nix",
  "powershell",
  "proto",
  "python",
  "query",
  "razor",
  "regex",
  "rust",
  "scss",
  "sql",
  "terraform",
  "tmux",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "xml",
  "zig",
}

-- Set treesitter grammars to runtimepath if running with nix
if kokovim.is_nix then
  local plugins_folder = require("kokovim.plugin").get_plugin_folder()
  vim.opt.runtimepath:append(plugins_folder .. "nvim-treesitter-grammars")
end

-- Enable treesitter highlighting automatically for all filetypes (except disabled ones)
-- The main branch requires manual activation via vim.treesitter.start()
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function(args)
    if not should_disable_treesitter(args.buf) then
      local filetype = vim.api.nvim_get_option_value("filetype", { buf = args.buf })
      -- Check if a parser exists for this filetype before trying to start treesitter
      local lang = vim.treesitter.language.get_lang(filetype)
      if lang and pcall(vim.treesitter.language.add, lang) then
        pcall(vim.treesitter.start, args.buf)
      end
    end
  end,
})

return {
  -- Main treesitter plugin
  kokovim.get_plugin_by_repo("nvim-treesitter/nvim-treesitter", {
    branch = "main",
    event = { "BufReadPost", "BufNewFile" },
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
    config = function()
      -- Setup nvim-treesitter with the new API
      require("nvim-treesitter").setup({
        install_dir = vim.fn.stdpath("data") .. "/site",
      })

      -- Install parsers (only when not running with nix)
      if not kokovim.is_nix then
        require("nvim-treesitter").install(parsers)
      end
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
      vim.keymap.set("n", "<leader>ut", function()
        tsc.toggle()
      end, { desc = "Toggle treesitter context" })
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
      vim.keymap.set({ "x", "o" }, "af", function()
        require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
      end, { desc = "Select outer function" })

      vim.keymap.set({ "x", "o" }, "if", function()
        require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
      end, { desc = "Select inner function" })

      vim.keymap.set({ "x", "o" }, "ac", function()
        require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
      end, { desc = "Select outer class" })

      vim.keymap.set({ "x", "o" }, "ic", function()
        require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
      end, { desc = "Select inner class" })

      -- Move keymaps - next start
      vim.keymap.set({ "n", "x", "o" }, "]m", function()
        require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")
      end, { desc = "Next function start" })

      vim.keymap.set({ "n", "x", "o" }, "]]", function()
        require("nvim-treesitter-textobjects.move").goto_next_start("@class.outer", "textobjects")
      end, { desc = "Next class start" })

      vim.keymap.set({ "n", "x", "o" }, "]d", function()
        require("nvim-treesitter-textobjects.move").goto_next_start("@conditional.outer", "textobjects")
      end, { desc = "Next conditional start" })

      -- Move keymaps - next end
      vim.keymap.set({ "n", "x", "o" }, "]M", function()
        require("nvim-treesitter-textobjects.move").goto_next_end("@function.outer", "textobjects")
      end, { desc = "Next function end" })

      vim.keymap.set({ "n", "x", "o" }, "][", function()
        require("nvim-treesitter-textobjects.move").goto_next_end("@class.outer", "textobjects")
      end, { desc = "Next class end" })

      -- Move keymaps - previous start
      vim.keymap.set({ "n", "x", "o" }, "[f", function()
        require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects")
      end, { desc = "Previous function start" })

      vim.keymap.set({ "n", "x", "o" }, "[[", function()
        require("nvim-treesitter-textobjects.move").goto_previous_start("@class.outer", "textobjects")
      end, { desc = "Previous class start" })

      vim.keymap.set({ "n", "x", "o" }, "[d", function()
        require("nvim-treesitter-textobjects.move").goto_previous_start("@conditional.outer", "textobjects")
      end, { desc = "Previous conditional start" })

      -- Move keymaps - previous end
      vim.keymap.set({ "n", "x", "o" }, "[F", function()
        require("nvim-treesitter-textobjects.move").goto_previous_end("@function.outer", "textobjects")
      end, { desc = "Previous function end" })

      vim.keymap.set({ "n", "x", "o" }, "[]", function()
        require("nvim-treesitter-textobjects.move").goto_previous_end("@class.outer", "textobjects")
      end, { desc = "Previous class end" })
    end,
  }),
}
