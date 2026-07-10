-------------------
---- AUTOSTART ----
-------------------

-- UWSM Launched ---
hl.on("hyprland.start", function()
	-- Re-enable DP-1, which is force-disabled during the tuigreet console
	-- (kernel video=DP-1:d) so tuigreet renders cleanly on DP-2 only.
	-- The connector reports fully "disconnected" at the DRM level, not just
	-- hidden from the console, so a compositor-side monitor call can't
	-- revive it -- it has to be flipped back on via sysfs directly.
	hl.exec_cmd("sudo /usr/local/bin/dp1-on")

	hl.exec_cmd("uwsm app -s b -t service -- /usr/lib/hyprpolkitagent/hyprpolkitagent")
	hl.exec_cmd("uwsm app -s b -t service -- awww-daemon")
	hl.exec_cmd("uwsm app -s b -t service -- waybar")
	-- hl.exec_cmd("uwsm app -s b -t service -- ~/.config/waybar/waybar.sh")
	hl.exec_cmd("uwsm app -s b -t service -- swaync")
	hl.exec_cmd("uwsm app -s b -t service -- hypridle")
	hl.exec_cmd("uwsm app -s b -t service -- wl-paste --watch cliphist store")
	hl.exec_cmd("uwsm app -s b -t service -- wl-paste --type image --watch cliphist store")

	-- Workspaces --

	-- Discord --
	hl.exec_cmd("uwsm app -s b -t service -- vesktop", { workspace = "name:Discord silent" })

	-- Main --
	hl.exec_cmd("uwsm app -- ghostty", {
		workspace = "name:Main",
		float = true,
		size = { 960, 600 },
	})

	-- Load hymission plugin
	hl.exec_cmd(
		"hyprctl plugin load /home/juicygoose007/.local/share/hypr/plugins/hymission-src/build-cmake/libhymission.so"
	)

	-- Focus Ghostty on Main workspace via DP-2
	hl.exec_cmd("hyprctl dispatch focusmonitor DP-2")
	hl.exec_cmd("hyprctl dispatch focuswindow class:^com\\.mitchellh\\.ghostty$")
end)
