{
  autoCmd = [
    {
      event = "FileType";
      desc = "Disable animation in grug";
      pattern = "grug-far";
      callback.__raw = ''
        function()
          vim.b.minianimate_disable = true
        end
      '';
    }

    {
      event = "User";
      desc = "Add mini file keymaps";
      pattern = "MiniFilesBufferCreate";
      callback.__raw = ''
        function(args)
          local buf_id = args.data.buf_id

          local function get_path()
            local entry = require('mini.files').get_fs_entry()
            if not entry then
              return nil
            end

            if entry.fs_type == 'directory' then
              return entry.path
            else
              return vim.fs.dirname(entry.path) -- Strip to parent directory
            end
          end

          vim.keymap.set('n', '<leader>N', function()
            local path = get_path()
            if path then
              require('easy-dotnet').createfile(path)
            else
              vim.notify('No folder selected', vim.log.levels.ERROR)
            end
          end, { buffer = buf_id, desc = "Create new dotnet file" })
        end
      '';
    }


  ];
}
