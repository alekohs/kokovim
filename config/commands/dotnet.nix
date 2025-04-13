{
  autoCmd = [
    {
      event = "User";
      desc = "Add dotnet create file to mini files";
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

          vim.keymap.set('n', '<C-n>', function()
            local path = get_path()
            if path then
              require('mini.files').close()
              vim.schedule(function()
                require('easy-dotnet').create_new_item(path, function()
                  require('mini.files').open()
                end)

              end)
            else
              vim.notify('No folder selected', vim.log.levels.ERROR)
            end
          end, { buffer = buf_id, desc = "Create new dotnet file" })
        end
      '';
    }


  ];
}
