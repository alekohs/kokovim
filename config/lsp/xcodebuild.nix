{
  pkgs,
  lib,
  self,
  system,
  ...
}:
{
  extraPackages = lib.optionals pkgs.stdenv.isDarwin [
    pkgs.jq
    pkgs.ruby
    pkgs.pipx
    pkgs.xcbeautify
  ];

  plugins.telescope = {
    enable = pkgs.stdenv.isDarwin;
    lazyLoad.enable = pkgs.stdenv.isDarwin;
    lazyLoad.settings = {
      event = "DeferredUIEnter";
      after.__raw = # Lua
        ''
          require("xcodebuild").setup()
        '';
    };
  };

  extraPlugins = lib.optionals pkgs.stdenv.isDarwin [
    self.packages.${system}.xcodebuild-nvim
  ];

  keymaps = lib.optionals pkgs.stdenv.isDarwin [
    {
      mode = "n";
      key = "<leader>dX";
      action = "<CMD>XcodebuildPicker<CR>";
      options = {
        desc = "Show Xcodebuild Actions";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>dxf";
      action = "<CMD>XcodebuildProjectManager<CR>";
      options = {
        desc = "Show Project Manager Actions";
        silent = true;
      };
    }

    {
      mode = "n";
      key = "<leader>dxb";
      action = "<CMD>XcodebuildBuild<CR>";
      options = {
        desc = "Build Project";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>dxB";
      action = "<CMD>XcodebuildBuildForTesting<CR>";
      options = {
        desc = "Build For Testing";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>dxr";
      action = "<CMD>XcodebuildBuildRun<CR>";
      options = {
        desc = "Build & Run Project";
        silent = true;
      };
    }

    {
      mode = "n";
      key = "<leader>dxt";
      action = "<CMD>XcodebuildTest<CR>";
      options = {
        desc = "Run Tests";
        silent = true;
      };
    }
    {
      mode = "v";
      key = "<leader>dxt";
      action = "<CMD>XcodebuildTestSelected<CR>";
      options = {
        desc = "Run Selected Tests";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>dxT";
      action = "<CMD>XcodebuildTestClass<CR>";
      options = {
        desc = "Run Current Test Class";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>dx.";
      action = "<CMD>XcodebuildTestRepeat<CR>";
      options = {
        desc = "Repeat Last Test Run";
        silent = true;
      };
    }

    {
      mode = "n";
      key = "<leader>dxl";
      action = "<CMD>XcodebuildToggleLogs<CR>";
      options = {
        desc = "Toggle Xcodebuild Logs";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>dxc";
      action = "<CMD>XcodebuildToggleCodeCoverage<CR>";
      options = {
        desc = "Toggle Code Coverage";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>dxC";
      action = "<CMD>XcodebuildShowCodeCoverageReport<CR>";
      options = {
        desc = "Show Code Coverage Report";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>dxe";
      action = "<CMD>XcodebuildTestExplorerToggle<CR>";
      options = {
        desc = "Toggle Test Explorer";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>dxs";
      action = "<CMD>XcodebuildFailingSnapshots<CR>";
      options = {
        desc = "Show Failing Snapshots";
        silent = true;
      };
    }

    {
      mode = "n";
      key = "<leader>dxp";
      action = "<CMD>XcodebuildPreviewGenerateAndShow<CR>";
      options = {
        desc = "Generate Preview";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>dx<CR>";
      action = "<CMD>XcodebuildPreviewToggle<CR>";
      options = {
        desc = "Toggle Preview";
        silent = true;
      };
    }

    {
      mode = "n";
      key = "<leader>dxd";
      action = "<CMD>XcodebuildSelectDevice<CR>";
      options = {
        desc = "Select Device";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>dxq";
      action = "<CMD>Telescope quickfix<CR>";
      options = {
        desc = "Show QuickFix List";
        silent = true;
      };
    }

    {
      mode = "n";
      key = "<leader>dxx";
      action = "<CMD>XcodebuildQuickfixLine<CR>";
      options = {
        desc = "Quickfix Line";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>dxa";
      action = "<CMD>XcodebuildCodeActions<CR>";
      options = {
        desc = "Show Code Actions";
        silent = true;
      };
    }
  ];
}
