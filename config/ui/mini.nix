{
  plugins.mini.lazyLoad = {
    enable = true;
    settings.event = "DeferredUIEnter";
  };

  plugins.mini.mockDevIcons = true;

  plugins.mini.modules.animate = {
    open.enable = false; # Do not animate pickers, presenting a black box on open and close
    close.enable = false;

    resize = {
      timing.__raw = ''require('mini.animate').gen_timing.linear({ duration = 50, unit = 'total' }) '';
    };
    scroll = {
      enable = true;
      timing.__raw = ''require('mini.animate').gen_timing.linear({ duration = 150, unit = 'total' }) '';
      subscroll.__raw = # Lua
        ''
          require('mini.animate').gen_subscroll.equal({
              predicate = function(total_scroll)
                if vim.g.mouse_scrolled then
                  vim.g.mouse_scrolled = false
                  return false
                end
                return total_scroll > 1
              end,
            })'';
    };
  };

  plugins.mini.modules.files = {
    windows = {
      preview = true;
      width_focus = 50;
      width_preview = 50;
    };

    options = {
      use_as_default_explorer = true;
    };
  };

  keymaps = [
    {
      mode = "n";
      action = "<CMD>lua MiniFiles.open(vim.api.nvim_buf_get_name(0), true)<CR>";
      key = "<leader>fm";
      options.desc = "Open mini.files (Directory of current file)";
    }
    {
      mode = "n";
      action = "<CMD>lua MiniFiles.open(vim.uv.cwd())<CR>";
      key = "<leader>fM";
      options.desc = "Open mini.files (CWD)";
    }
  ];

  plugins.mini.modules.icons = { };

  extraConfigLua = ''
    -- Detect mouse scroll events
    local mouse_keys = { "Up", "Down" }
    for _, scroll in ipairs(mouse_keys) do
      local key = "<ScrollWheel" .. scroll .. ">"
      vim.keymap.set({ "", "i" }, key, function()
        vim.g.mouse_scrolled = true
        return key
      end, { expr = true })
    end
  '';

}
