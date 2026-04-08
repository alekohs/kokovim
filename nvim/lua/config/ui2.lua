-- UI2: floating cmdline and messages (Neovim 0.12+)
if vim.fn.has("nvim-0.12") == 1 then
  require("vim._core.ui2").enable({
    enable = true,
    msg = {
      targets = {
        [""]          = "msg",
        empty         = "cmd",
        bufwrite      = "msg",
        confirm       = "cmd",
        emsg          = "pager",
        echo          = "msg",
        echomsg       = "msg",
        echoerr       = "pager",
        completion    = "cmd",
        list_cmd      = "pager",
        lua_error     = "pager",
        lua_print     = "msg",
        progress      = "pager",
        rpc_error     = "pager",
        quickfix      = "msg",
        search_cmd    = "cmd",
        search_count  = "cmd",
        shell_cmd     = "pager",
        shell_err     = "pager",
        shell_out     = "pager",
        shell_ret     = "msg",
        undo          = "msg",
        verbose       = "pager",
        wildlist      = "cmd",
        wmsg          = "msg",
        typed_cmd     = "cmd",
      },
      cmd = {
        height = 0.5,
      },
      dialog = {
        height = 0.5,
      },
      msg = {
        height = 0.3,
        timeout = 5000,
      },
      pager = {
        height = 0.5,
      },
    },
  })

  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "msg", "pager", "dialog" },
    callback = function()
      local win = vim.api.nvim_get_current_win()
      vim.api.nvim_win_set_config(win, { border = "rounded" })
      vim.wo[win].winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder"
    end,
  })

  vim.api.nvim_create_autocmd("FileType", {
    pattern = "cmd",
    callback = function()
      local win = vim.api.nvim_get_current_win()
      vim.wo[win].winhighlight = "Normal:NormalFloat"
    end,
  })
end
