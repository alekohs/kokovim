-- Only configure this if it's Darwin (macos)
return kokovim.get_plugin_by_repo("wojciech-kulik/xcodebuild.nvim", {
  cond = kokovim.is_darwin,
  dependencies = {
    kokovim.get_plugin_by_repo("nvim-telescope/telescope.nvim"),
    kokovim.get_plugin_by_repo("MunifTanjim/nui.nvim"),
    kokovim.get_plugin_by_repo("stevearc/oil.nvim"),
    kokovim.get_plugin_by_repo("nvim-treesitter/nvim-treesitter"),
    kokovim.get_plugin_by_repo("folke/snacks.nvim"),
  },
  opts = {
    integrations = {
      nvim_tree = {
        enabled = false,
      },
    },
    show_build_progress_bar = false,
    logs = {
      auto_open_on_success_tests = false,
      auto_open_on_failed_tests = false,
      auto_open_on_success_build = false,
      auto_open_on_failed_build = false,
      auto_focus = false,
      auto_close_on_app_launch = true,
      only_summary = true,
    },
    code_coverage = {
      enabled = true,
    },
  },
  config = function(_, opts)
    require("xcodebuild").setup(opts)

    vim.keymap.set("n", "<leader>xsA", "<cmd>XcodebuildPicker<cr>", { desc = "Show Xcodebuild Actions" })
    vim.keymap.set("n", "<leader>xsf", "<cmd>XcodebuildProjectManager<cr>", { desc = "Show Project Manager Actions" })

    vim.keymap.set("n", "<leader>xsb", "<cmd>XcodebuildBuild<cr>", { desc = "Build Project" })
    vim.keymap.set("n", "<leader>xsB", "<cmd>XcodebuildBuildForTesting<cr>", { desc = "Build For Testing" })
    vim.keymap.set("n", "<leader>xsr", "<cmd>XcodebuildBuildRun<cr>", { desc = "Build & Run Project" })

    vim.keymap.set("n", "<leader>xst", "<cmd>XcodebuildTest<cr>", { desc = "Run Tests" })
    vim.keymap.set("v", "<leader>xst", "<cmd>XcodebuildTestSelected<cr>", { desc = "Run Selected Tests" })
    vim.keymap.set("n", "<leader>xsT", "<cmd>XcodebuildTestClass<cr>", { desc = "Run This Test Class" })

    vim.keymap.set("n", "<leader>xsl", "<cmd>XcodebuildToggleLogs<cr>", { desc = "Toggle Xcodebuild Logs" })
    vim.keymap.set("n", "<leader>xsc", "<cmd>XcodebuildToggleCodeCoverage<cr>", { desc = "Toggle Code Coverage" })
    vim.keymap.set("n", "<leader>xsC", "<cmd>XcodebuildShowCodeCoverageReport<cr>", { desc = "Show Code Coverage Report" })
    vim.keymap.set("n", "<leader>xse", "<cmd>XcodebuildTestExplorerToggle<cr>", { desc = "Toggle Test Explorer" })
    vim.keymap.set("n", "<leader>xss", "<cmd>XcodebuildFailingSnapshots<cr>", { desc = "Show Failing Snapshots" })

    vim.keymap.set("n", "<leader>xsd", "<cmd>XcodebuildSelectDevice<cr>", { desc = "Select Device" })
    vim.keymap.set("n", "<leader>xsp", "<cmd>XcodebuildSelectTestPlan<cr>", { desc = "Select Test Plan" })
    vim.keymap.set("n", "<leader>xsq", "<cmd>Telescope quickfix<cr>", { desc = "Show QuickFix List" })

    vim.keymap.set("n", "<leader>xsx", "<cmd>XcodebuildQuickfixLine<cr>", { desc = "Quickfix Line" })
    vim.keymap.set("n", "<leader>xsa", "<cmd>XcodebuildCodeActions<cr>", { desc = "Show Code Actions" })
  end,
})
