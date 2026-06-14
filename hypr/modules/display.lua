------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
	output = "DP-2",
	mode = "2560x1440@165.00Hz",
	position = "1920x0",
	scale = 1,
	vrr = 2,
})

hl.monitor({
	output = "DP-1",
	mode = "1920x1080@60.000",
	position = "0x0",
	scale = 1,
})

----------------
----  MISC  ----
----------------

hl.config({
	misc = {
		force_default_wallpaper = 1,
		disable_hyprland_logo = true,
	},
})

hl.config({
	cursor = {
		min_refresh_rate = 24,
	},
})
