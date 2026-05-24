-- Dashboard
vim.api.nvim_create_autocmd("FileType", {
	pattern = "dashboard",
	once = true,
	callback = function()
		vim.b.miniindentscope_disable = true
		require("ibl").setup_buffer(0, { enabled = false })
		vim.api.nvim_set_hl(0, "DashboardHeader", { fg = "#33b1ff", bold = true })
		vim.api.nvim_set_hl(0, "DashboardFooter", { fg = "#525252", italic = true })
		vim.api.nvim_set_hl(0, "DashboardShortCut", { fg = "#ee5396" })
		vim.api.nvim_set_hl(0, "DashboardDesc", { fg = "#dde1e7" })
		vim.api.nvim_set_hl(0, "DashboardIcon", { fg = "#42be65" })
	end,
})
require("dashboard").setup({
	theme = "hyper",
	config = {
		header = {
			"",
			"  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
			"  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
			"  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
			"  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
			"  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
			"  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
			"",
			"                     ネオヴィム                     ",
			"",
		},
		shortcut = {
			{
				desc = "  Files",
				group = "DashboardShortCut",
				action = "FzfLua files",
				key = "f",
			},
			{
				desc = "  Grep",
				group = "DashboardShortCut",
				action = "FzfLua live_grep",
				key = "g",
			},
			{
				desc = "  Config",
				group = "DashboardShortCut",
				action = "edit ~/.config/nvim/init.lua",
				key = "c",
			},
			{
				desc = "  Explorer",
				group = "DashboardShortCut",
				action = "Yazi",
				key = "e",
			},
			{
				desc = "  New File",
				group = "DashboardShortCut",
				action = function()
					vim.ui.input({ prompt = "New file: " }, function(input)
						if input and input ~= "" then
							vim.cmd("edit " .. vim.fn.fnameescape(input))
						end
					end)
				end,
				key = "n",
			},
			{
				desc = "  Quit",
				group = "DashboardShortCut",
				action = "qa",
				key = "q",
			},
		},
		project = { enable = false },
		footer = { "", "  neovim  —  stay sharp" },
	},
})

