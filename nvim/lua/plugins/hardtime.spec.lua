-- Learn how to use vim the correct way, notifications when you're repeating yourself
return kokovim.get_plugin_by_repo("m4xshen/hardtime.nvim", {
   lazy = false,
   dependencies = { kokovim.get_plugin_by_repo("MunifTanjim/nui.nvim") },
   opts = {},
})
