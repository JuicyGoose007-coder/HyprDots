-- Colorscheme
vim.g.nord_disable_background = true
vim.g.nord_borders = false
vim.g.nord_contrast = false
require("nord").set()
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

-- Matugen color overrides (syntax + statusline), reusable for live reload
local function apply_matugen_colors()
	package.loaded["modules.matugen-colors"] = nil
	local ok, c = pcall(require, "modules.matugen-colors")
	if not ok then
		return
	end

	local keyword_groups = {
		"Keyword",
		"Conditional",
		"Repeat",
		"Exception",
		"Label",
		"@keyword",
		"@keyword.return",
		"@keyword.conditional",
		"@keyword.repeat",
		"@keyword.operator",
		"@keyword.function",
		"@keyword.import",
		"@keyword.exception",
	}
	local string_groups = {
		"String",
		"Character",
		"@string",
		"@string.escape",
		"@string.special",
	}
	local func_groups = {
		"Function",
		"@function",
		"@function.call",
		"@function.method",
		"@function.method.call",
		"@function.builtin",
		"@constructor",
	}
	local comment_groups = {
		"Comment",
		"@comment",
		"@comment.line",
		"@comment.block",
	}
	for _, g in ipairs(keyword_groups) do
		vim.api.nvim_set_hl(0, g, { fg = c.keyword })
	end
	for _, g in ipairs(string_groups) do
		vim.api.nvim_set_hl(0, g, { fg = c.str })
	end
	for _, g in ipairs(func_groups) do
		vim.api.nvim_set_hl(0, g, { fg = c.func })
	end
	for _, g in ipairs(comment_groups) do
		vim.api.nvim_set_hl(0, g, { fg = c.comment, italic = true })
	end

	vim.api.nvim_set_hl(0, "MiniStatuslineModeNormal", { fg = c.on_normal, bg = c.normal, bold = true })
	vim.api.nvim_set_hl(0, "MiniStatuslineModeInsert", { fg = c.on_insert, bg = c.insert, bold = true })
	vim.api.nvim_set_hl(0, "MiniStatuslineModeVisual", { fg = c.on_visual, bg = c.visual, bold = true })
	vim.api.nvim_set_hl(0, "MiniStatuslineModeReplace", { fg = c.on_replace, bg = c.replace, bold = true })
	vim.api.nvim_set_hl(0, "MiniStatuslineModeCommand", { fg = c.on_command, bg = c.command, bold = true })
	vim.api.nvim_set_hl(0, "MiniStatuslineFilename", { fg = c.fg, bg = c.bg_mid })
	vim.api.nvim_set_hl(0, "MiniStatuslineFileinfo", { fg = c.fg_muted, bg = c.bg })
	vim.api.nvim_set_hl(0, "MiniStatuslineInactive", { fg = c.fg_muted, bg = c.bg })
end

apply_matugen_colors()

local watcher = vim.uv.new_fs_event()
if watcher then
	watcher:start(
		vim.fn.stdpath("config") .. "/lua/modules",
		{ recursive = false },
		vim.schedule_wrap(function(err, fname, _events)
			if not err and fname == "matugen-colors.lua" then
				apply_matugen_colors()
			end
		end)
	)
end

-- Experimental UI2: floating cmdline and messages
vim.o.cmdheight = 1
require("vim._core.ui2").enable({
	enable = true,
	msg = {
		targets = {
			[""] = "msg",
			empty = "cmd",
			bufwrite = "msg",
			confirm = "cmd",
			emsg = "pager",
			echo = "msg",
			echomsg = "msg",
			echoerr = "pager",
			completion = "cmd",
			list_cmd = "pager",
			lua_error = "pager",
			lua_print = "msg",
			progress = "pager",
			rpc_error = "pager",
			quickfix = "msg",
			search_cmd = "cmd",
			search_count = "cmd",
			shell_cmd = "pager",
			shell_err = "pager",
			shell_out = "pager",
			shell_ret = "msg",
			undo = "msg",
			verbose = "pager",
			wildlist = "cmd",
			wmsg = "msg",
			typed_cmd = "cmd",
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

-- UI
-- require("vim._core.ui2").enable({
-- 	enable = true, -- Whether to enable or disable the UI.
-- 	msg = { -- Options related to the message module.
-- 		---@type 'cmd'|'msg' Default message target, either in the
-- 		---cmdline or in a separate ephemeral message window.
-- 		---@type string|table<string, 'cmd'|'msg'|'pager'> Default message target
-- 		---or table mapping |ui-messages| kinds and triggers to a target.
-- 		targets = "cmd",
-- 		cmd = { -- Options related to messages in the cmdline window.
-- 			height = 0.5, -- Maximum height while expanded for messages beyond 'cmdheight'.
-- 		},
-- 		dialog = { -- Options related to dialog window.
-- 			height = 0.5, -- Maximum height.
-- 		},
-- 		msg = { -- Options related to msg window.
-- 			height = 0.5, -- Maximum height.
-- 			timeout = 4000, -- Time a message is visible in the message window.
-- 		},
-- 		pager = { -- Options related to message window.
-- 			height = 1, -- Maximum height.
-- 		},
-- 	},
-- })
