-------------------
---- AUTOSTART ----
-------------------

-- UWSM Launched ---
hl.on("hyprland.start", function()
	hl.exec_cmd("uwsm app -s b -t service -- /usr/lib/hyprpolkitagent/hyprpolkitagent")
	hl.exec_cmd("uwsm app -s b -t service -- awww-daemon")
	hl.exec_cmd("uwsm app -s b -t service -- ~/.config/waybar/waybar.sh")
	hl.exec_cmd("uwsm app -s b -t service -- swaync")
	hl.exec_cmd("uwsm app -s b -t service -- hypridle")
	hl.exec_cmd("uwsm app -s b -t service -- wl-paste --watch cliphist store")
	hl.exec_cmd("uwsm app -s b -t service -- wl-paste --type image --watch cliphist store")

	-- Workspaces --
	-- Discord --
	hl.exec_cmd("uwsm app -s b -t service -- vesktop")
	-- hl.exec_cmd("sleep 2 && uwsm app -s b -t service -- ghostty --title=riptide -e zsh -ic riptide")

	-- Main --
	hl.exec_cmd("uwsm app -- ghostty", { workspace = "name:Main" })
	-- hl.exec_cmd("uwsm app -- zen-browser", { workspace = "name:Main" })

	-- Normal start --
	hl.exec_cmd("hymission")

	-- Focus Ghostty on Main workspace via DP-2
	hl.exec_cmd("hyprctl dispatch focusmonitor DP-2")
	hl.exec_cmd("hyprctl dispatch focuswindow class:^com\\.mitchellh\\.ghostty$")
end)
