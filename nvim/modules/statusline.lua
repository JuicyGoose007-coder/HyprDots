-- Statusline
vim.api.nvim_set_hl(0, "MiniStatuslineModeNormal", { fg = "#161616", bg = "#33b1ff", bold = true })
vim.api.nvim_set_hl(0, "MiniStatuslineModeInsert", { fg = "#161616", bg = "#78a9ff", bold = true })
vim.api.nvim_set_hl(0, "MiniStatuslineModeVisual", { fg = "#161616", bg = "#ee5396", bold = true })
vim.api.nvim_set_hl(0, "MiniStatuslineModeReplace", { fg = "#161616", bg = "#ff7eb6", bold = true })
vim.api.nvim_set_hl(0, "MiniStatuslineModeCommand", { fg = "#161616", bg = "#be95ff", bold = true })
vim.api.nvim_set_hl(0, "MiniStatuslineFilename", { fg = "#dde1e7", bg = "#262626" })
vim.api.nvim_set_hl(0, "MiniStatuslineFileinfo", { fg = "#525252", bg = "#161616" })
vim.api.nvim_set_hl(0, "MiniStatuslineInactive", { fg = "#525252", bg = "#161616" })
local statusline = require("mini.statusline")
local mode_map = {
	["n"] = { "N", "MiniStatuslineModeNormal" },
	["v"] = { "V", "MiniStatuslineModeVisual" },
	["V"] = { "V-L", "MiniStatuslineModeVisual" },
	["\22"] = { "V-B", "MiniStatuslineModeVisual" },
	["s"] = { "S", "MiniStatuslineModeVisual" },
	["S"] = { "S-L", "MiniStatuslineModeVisual" },
	["i"] = { "I", "MiniStatuslineModeInsert" },
	["R"] = { "R", "MiniStatuslineModeReplace" },
	["c"] = { "C", "MiniStatuslineModeCommand" },
	["r"] = { "P", "MiniStatuslineModeOther" },
	["!"] = { "Sh", "MiniStatuslineModeOther" },
	["t"] = { "T", "MiniStatuslineModeOther" },
}
statusline.setup({
	content = {
		active = function()
			local m = mode_map[vim.fn.mode()] or { "?", "MiniStatuslineModeOther" }
			local mode, mode_hl = m[1], m[2]
			local git = statusline.section_git({ trunc_width = 40 })
			local diff = statusline.section_diff({ trunc_width = 75 })
			local diagnostics = statusline.section_diagnostics({ trunc_width = 75 })
			local lsp = statusline.section_lsp({ trunc_width = 75 })
			local filename = statusline.section_filename({ trunc_width = 140 })
			local fileinfo = statusline.section_fileinfo({ trunc_width = 120 })
			local location = statusline.section_location({ trunc_width = 75 })
			local search = statusline.section_searchcount({ trunc_width = 75 })

			return statusline.combine_groups({
				{ hl = mode_hl, strings = { mode } },
				{ hl = "MiniStatuslineDevinfo", strings = { git, diff, diagnostics, lsp } },
				"%<",
				{ hl = "MiniStatuslineFilename", strings = { filename } },
				"%=",
				{ hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
				{ hl = mode_hl, strings = { search, location } },
			})
		end,
	},
})

