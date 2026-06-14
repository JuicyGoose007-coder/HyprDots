-- Colorscheme
vim.g.nord_disable_background = true
vim.g.nord_borders = false
vim.g.nord_contrast = false
require("nord").set()
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

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
