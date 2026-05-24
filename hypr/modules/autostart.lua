-------------------
---- AUTOSTART ----
-------------------

-- UWSM Launched
hl.on("hyprland.start", function()
	hl.exec_cmd("uwsm app -s b -t service -- /usr/lib/hyprpolkitagent/hyprpolkitagent")
	hl.exec_cmd("uwsm app -s b -t service -- awww-daemon")
	hl.exec_cmd("uwsm app -s b -t service -- ~/.config/waybar/waybar.sh")
	hl.exec_cmd("uwsm app -s b -t service -- swaync")
	hl.exec_cmd("uwsm app -s b -t service -- hypridle")
	hl.exec_cmd("uwsm app -- ghostty", { workspace = "name:Main" })
	hl.exec_cmd("uwsm app -- firefox", { workspace = "name:Main" })
	hl.exec_cmd("uwsm app -s b -t service -- vesktop")
	hl.exec_cmd("uwsm app -s b -t service -- wl-paste --watch cliphist store")
	hl.exec_cmd("uwsm app -s b -t service -- wl-paste --type image --watch cliphist store")

	-- Normal start
	hl.exec_cmd("hymission")
	hl.exec_cmd("hyprctl dispatch workspace name:Main")
end)
