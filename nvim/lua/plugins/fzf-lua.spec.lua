local function close_oil_get_cwd()
  if vim.bo.filetype ~= "oil" then return nil end
  local dir = require("oil").get_current_dir()
  require("oil").close()
  return dir
end

return kokovim.get_plugin_by_repo("ibhagwan/fzf-lua", {
  cond = not vim.g.vscode,
  opts = {
    fzf_colors = {
      ["fg"]      = { "fg", "Normal" },
      ["bg"]      = { "bg", "Normal" },
      ["hl"]      = { "fg", "Comment" },
      ["fg+"]     = { "fg", "CursorLine" },
      ["bg+"]     = { "bg", "CursorLine" },
      ["hl+"]     = { "fg", "Statement" },
      ["info"]    = { "fg", "Comment" },
      ["border"]  = { "fg", "WinSeparator" },
      ["prompt"]  = { "fg", "Function" },
      ["pointer"] = { "fg", "Exception" },
      ["marker"]  = { "fg", "Keyword" },
      ["spinner"] = { "fg", "Label" },
      ["header"]  = { "fg", "Comment" },
      ["gutter"]  = { "bg", "Normal" },
    },
    files = {
      ignore = { "__virtual%.cs$" },
    },
  },
  dependencies = { kokovim.get_plugin("mini-nvim", "echasnovski/mini.icons") },
  config = function(_, opts)
    require("fzf-lua").setup(opts)
    require("fzf-lua").register_ui_select()
  end,
  keys = {
    { "<leader><space>", function() require("fzf-lua").files({ cwd = close_oil_get_cwd() }) end, desc = "Find files" },
    { "<leader>/", function() require("fzf-lua").live_grep({ cwd = close_oil_get_cwd() }) end, desc = "Find live grep" },
    { "<leader>fb", function() require("fzf-lua").buffers() end, desc = "Find buffers" },
    { "<leader>.", function() require("fzf-lua").resume() end, desc = "Resume last search" },
    { "<leader>fr", function() require("fzf-lua").oldfiles() end, desc = "Find recent files" },
    { "<leader>fw", function() require("fzf-lua").grep_cword() end, desc = "Find word under cursor" },
    { "<leader>fv", function() require("fzf-lua").grep_visual() end, mode = "x", desc = "Find word under visual" },

    {
      "<leader>cd",
      function() require("fzf-lua").lsp_document_diagnostics() end,
      desc = "Document diagnostics",
    },

    {
      "<leader>cD",
      function() require("fzf-lua").lsp_workspace_diagnostics() end,
      desc = "Workspace diagnostics",
    },

    {
      "<leader>cs",
      function() require("fzf-lua").lsp_document_symbols() end,
      desc = "Document symbols",
    },
    {
      "<leader>cS",
      function() require("fzf-lua").lsp_live_workspace_symbols() end,
      desc = "Workspace symbols (live)",
    },

    {
      "<leader>ci",
      function() require("fzf-lua").lsp_incoming_calls() end,
      desc = "Incoming calls",
    },
    {
      "<leader>co",
      function() require("fzf-lua").lsp_outgoing_calls() end,
      desc = "Outgoing calls",
    },

    { "<leader>gs", function() require("fzf-lua").git_status() end, desc = "Find git status" },
    { "<leader>gf", function() require("fzf-lua").git_files() end, desc = "Find git files" },
    { "<leader>gb", function() require("fzf-lua").git_blame() end, desc = "Git blame" },
    { "<leader>gL", function() require("fzf-lua").git_bcommits() end, desc = "Git log (buffer)" },

    { "<leader>sR", function() require("fzf-lua").registers() end, desc = "Search registers" },
    { "<leader>sk", function() require("fzf-lua").keymaps() end, desc = "Search keymaps" },
    { "<leader>sh", function() require("fzf-lua").helptags() end, desc = "Search help tags" },
    { "<leader>sm", function() require("fzf-lua").marks() end, desc = "Search marks" },
    { "<leader>sM", function() require("fzf-lua").man_pages() end, desc = "Search man pages" },
    { "<leader>sq", function() require("fzf-lua").quickfix() end,  desc = "Search quickfix list" },
    { "<leader>sQ", function() require("fzf-lua").loclist() end,   desc = "Search location list" },
    { "<leader>s:", function() require("fzf-lua").command_history() end, desc = "Command history" },
    { "<leader>s/", function() require("fzf-lua").search_history() end,  desc = "Search history" },
    {
      "<leader>st",
      function()
        require("fzf-lua").grep({ search = [[\b(TODO|FIXME|HACK|NOTE|BUG|XXX)\b]], no_esc = true })
      end,
      desc = "Search todo comments",
    },

    { "<leader>uc", function() require("fzf-lua").colorschemes() end, desc = "Find colorschemes" },
    { "<leader>uC", function() require("fzf-lua").awesome_colorschemes() end, desc = "Find awesome colorschemes" },
  },
})
