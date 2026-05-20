#!/usr/bin/env python3
import json
import subprocess
import html
import re
import time
import os
import socket

MAX_TITLE_LEN = 42

def hyprctl_json(command):
    try:
        output = subprocess.check_output(["hyprctl", "-j", command], text=True)
        return json.loads(output)
    except Exception:
        return None

def print_status():
    window = hyprctl_json("activewindow")

    top_line = "Desktop"
    bottom_line = ""

    if window and window.get("class"):
        top_line = window["class"]
        title = window.get("title", "") or ""
        app_id = top_line.lower()

        if "discord" in app_id or "vesktop" in app_id:
            title = re.sub(r"^\(\d+\)\s*", "", title)
            title = re.sub(r"^Discord\s*\|\s*", "", title)

        if len(title) > MAX_TITLE_LEN:
            title = title[:MAX_TITLE_LEN - 3]

        bottom_line = title
    else:
        ws = hyprctl_json("activeworkspace")
        ws_id = ws.get("name", 1) if ws else 1
        top_line = f"Workspace {ws_id}"

    top_line = html.escape(top_line)
    bottom_line = html.escape(bottom_line)

    text = (
        f"<span size='small' foreground='#a6adc8' rise='-1000'>{top_line}</span> "
        f"<span size='8500' weight='bold' foreground='#ffffff'>{bottom_line}</span>"
    )

    print(json.dumps({
        "text": text,
        "class": "custom-window",
        "tooltip": f"{top_line}: {bottom_line}"
    }), flush=True)

print_status()

instance = os.environ.get("HYPRLAND_INSTANCE_SIGNATURE")
if instance:
    socket_path = f"{os.environ.get('XDG_RUNTIME_DIR', '/tmp')}/hypr/{instance}/.socket2.sock"
    try:
        sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
        sock.connect(socket_path)
        sock_file = sock.makefile("r")
        for line in sock_file:
            event = line.strip().split(">>")[0]
            if event in ("activewindow", "workspace", "openwindow", "closewindow", "movewindow"):
                print_status()
    except Exception:
        pass
else:
    while True:
        time.sleep(1)
        print_status()
