-- Which-key
require("which-key").setup()

-- Indent guides
require("ibl").setup({
	indent = { char = "│" },
	scope = { enabled = true },
})

-- File explorer
require("yazi").setup({
	view_options = { show_hidden = true },
})

-- Undotree
require("undotree").setup()

-- Fuzzy finder
require("fzf-lua").setup()

-- Neo-tree
require("neo-tree").setup({
	window = { width = 30 },
	filesytem = {
		follow_current_file = { enabled = true },
		filtered_items = { visible = true },
	},
})

vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		require("neo-tree.command").execute({ action = "show" })
		vim.cmd("wincmd p")
	end,
})

vim.api.nvim_create_autocmd("QuitPre", {
	callback = function()
		local wins = vim.api.nvim_list_wins()
		local tree_wins = vim.tbl_filter(function(w)
			return vim.bo[vim.api.nvim_win_get_buf(w)].filetype == "neo-tree"
		end, wins)
		local float_wins = vim.tbl_filter(function(w)
			return vim.api.nvim_win_get_config(w).relative ~= ""
		end, wins)
		if #wins - #tree_wins - #float_wins == 1 then
			for _, w in ipairs(tree_wins) do
				vim.api.nvim_win_close(w, true)
			end
		end
	end,
})
