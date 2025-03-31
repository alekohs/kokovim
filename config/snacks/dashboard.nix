{
  plugins.snacks = {
    enable = true;
    settings = {
      dashboard = {
        preset = {
          header = ''
             _  _____  _  _______   ___ __  __
            | |/ / _ \| |/ / _ \ \ / (_)  \/  |
            | ' < (_) | ' < (_) \ V /| | |\/| |
            |_|\_\___/|_|\_\___/ \_/ |_|_|  |_|
          '';
        };

        sections = [
          {
            section = "header";
          }
          {
            icon = " ";
            title = "Recent Files";
            __unkeyed-1.__raw = "require('snacks').dashboard.sections.recent_files({cwd = true})";
            pane = 1;
            indent = 1;
            padding = 1;
          }

          {
            icon = " ";
            title = "Keymaps";
            section = "keys";
            indent = 1;
            padding = 1;
          }
          {
            pane = 1;
            icon = " ";
            desc = "Browse Repo";
            padding = 1;
            indent = 1;
            key = "b";
            action.__raw = ''
              function()
                Snacks.gitbrowse()
              end'';
          }
          {
            section = "terminal";
            pane = 2;
            cmd = "";
            height = 5;
            padding = 2;
          }
          {
            icon = " ";
            title = "Projects";
            section = "projects";
            pane = 2;
            indent = 1;
            padding = 1;
          }

          {
            __raw = ''
              function()
                local in_git = Snacks.git.get_root() ~= nil
                local is_github_repo = vim.fn.systemlist("git remote get-url origin")[1]:match("github.com")

                local cmds = (is_github_repo and {
                  {
                    title = "Open Issues",
                    cmd = "gh issue list -L 3",
                    key = "i",
                    action = function()
                      if (is_github_repo) then
                        vim.fn.jobstart("gh issue list --web", { detach = true })
                      else
                        print("This is not a Github repo")
                      end
                    end,
                    icon = " ",
                    height = 3,
                    indent = 1,
                  },
                  {
                    icon = " ",
                    title = "Open PRs",
                    cmd = "gh pr list -L 3",
                    key = "p",
                    action = function()
                      if (is_github_repo) then
                        vim.fn.jobstart("gh pr list --web", { detach = true })
                      else
                        print("This is not a Github repo")
                      end
                    end,
                    height = 3,
                    indent = 1,
                  },
                  {
                    icon = " ",
                    title = "Git Status",
                    cmd = "git --no-pager diff --stat -B -M -C",
                    height = 3,
                    indent = 1,
                  },
                } or {
                  {
                    icon = " ",
                    title = "Git Status",
                    cmd = "git --no-pager diff --stat -B -M -C",
                    height = 3,
                    indent = 1,
                  }
                })

                return vim.tbl_map(function(cmd)
                  return vim.tbl_extend("force", {
                    pane = 2,
                    section = "terminal",
                    enabled = in_git,
                    padding = 1,
                    ttl = 5 * 60,
                    indent = 1,
                  }, cmd)
                end, cmds)
              end
            '';
          }
        ];
      };
    };
  };
}
