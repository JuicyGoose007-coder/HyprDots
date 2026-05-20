# Hue-Anchored Accent Extraction Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace fixed-slot accent colour mapping in `theme-switcher.sh` with best-hue-match selection across all 16 wallust palette slots, with hue-synthesis fallback for colours absent from the wallpaper.

**Architecture:** Add `pick_best_hue()` — a single-awk function that scans all 16 wallust palette slots, returns the slot whose hue is closest to a semantic target, and synthesises a colour (preserving wallpaper S/L) only when no slot is within the tolerance threshold. Refactor `extract_palette()` to call this for each accent role instead of hardcoding slot numbers. BG/FG extraction remains unchanged.

**Why the current approach fails:** `wallust` maps image colours to 16 terminal ANSI slots. For warm/crimson wallpapers the script then blindly uses `color14` for `ACCENT_BLUE` — but `color14=#730562` on the current wallpaper is a dark purple, giving a magenta "blue." Actual blues exist in `color2`, `color10`, `color13` and are never consulted. The fix: scan all 16 slots for best hue match per role.

**Tech Stack:** Bash 5, GNU awk (already present), jq (already present), wallust

---

## Files

| Action | Path | Change |
|--------|------|--------|
| Modify | `~/.config/rofi/theme-switcher.sh` | Add `pick_best_hue()` helper; refactor `extract_palette()` accent block |

No other files change — `colors.rasi` and all downstream configs are regenerated automatically by the existing `generate_*` functions.

---

### Task 1: Confirm the problem with the live palette

**Files:**
- Read: `~/.cache/theme-switcher/palette.json`

- [ ] **Step 1: Print all palette slots and their hues**

```bash
cache="$HOME/.cache/theme-switcher/palette.json"
jq -r 'to_entries[] | "\(.key): \(.value)"' "$cache"
```

Expected output: 18 lines (`background`, `foreground`, `cursor`, `color0`–`color15`).

- [ ] **Step 2: Map current script slot assignments to their actual hues**

The script currently uses these fixed slots for accents:

| Variable | Slot | Current wallpaper value | Hue (approx) | Correct? |
|----------|------|------------------------|--------------|---------|
| ACCENT_PINK | color12 | #970629 | ~355° red | ✓ |
| ACCENT_GREEN | color11 | #064C9E | ~218° blue | ✗ |
| ACCENT_BLUE | color14 | #730562 | ~307° magenta | ✗ |
| ACCENT_PURPLE | color13 | #064D89 | ~213° blue | ✗ |
| ACCENT_CYAN | color10 | #0670A6 | ~204° blue | close |
| ACCENT_LBLUE | color9 | #CA0516 | ~357° red | ✗ |
| ACCENT_MAGENTA | color5 | #053F75 | ~211° blue | ✗ |
| ACCENT_TEAL | color3 | #06438C | ~216° blue | close |
| ACCENT_SKY | color4 | #7F0525 | ~349° red | ✗ |

Actual blues in palette: `color2=#066494`, `color10=#0670A6`, `color11=#064C9E`, `color13=#064D89` — never used for ACCENT_BLUE.

This analysis confirms the fix is needed. No code change in this task.

---

### Task 2: Add `pick_best_hue()` helper

**Files:**
- Modify: `~/.config/rofi/theme-switcher.sh` — insert after `hex_alpha()` function (~line 191), before `extract_palette()`

- [ ] **Step 1: Insert `pick_best_hue()` after `hex_alpha()`**

The insertion point is immediately after this block (~line 191):
```bash
hex_alpha() {
  local hex="${1#\#}"
  local alpha="$2"
  printf '#%s%s' "$hex" "$alpha"
}
```

Add after it:

```bash
# Scan a space-separated list of hex colours for the one whose hue is closest
# to target_h (degrees). If the closest is within max_dist degrees, return it
# (brightened to min RGB 220). Otherwise synthesise a colour at target_h,
# preserving the closest slot's saturation and lightness from the wallpaper.
# Usage: pick_best_hue "<c0 c1 … c15>" <target_hue> [max_dist=90]
pick_best_hue() {
  local colors="$1" target="$2" max_dist="${3:-90}"
  local result
  result=$(awk -v colors="$colors" -v target="$target" -v max_dist="$max_dist" '
    function hex2hsl(hex,  out,r,g,b,mx,mn,d,h,s,l) {
      sub(/^#/,"",hex)
      r=int("0x" substr(hex,1,2))/255
      g=int("0x" substr(hex,3,2))/255
      b=int("0x" substr(hex,5,2))/255
      mx=(r>g)?((r>b)?r:b):((g>b)?g:b)
      mn=(r<g)?((r<b)?r:b):((g<b)?g:b)
      l=(mx+mn)/2; d=mx-mn
      if (d==0) { h=0; s=0 } else {
        s=(l>0.5)?d/(2-mx-mn):d/(mx+mn)
        if      (mx==r) h=((g-b)/d)+((g<b)?6:0)
        else if (mx==g) h=((b-r)/d)+2
        else            h=((r-g)/d)+4
        h*=60
      }
      out[0]=h; out[1]=s; out[2]=l
    }
    function h2c(p,q,t) {
      if (t<0) t+=1; if (t>1) t-=1
      if (t<1/6) return p+(q-p)*6*t
      if (t<1/2) return q
      if (t<2/3) return p+(q-p)*(2/3-t)*6
      return p
    }
    function hsl2hex(h,s,l,  q,p,hh,r,g,b) {
      hh=h/360
      if (s==0) { r=l; g=l; b=l } else {
        q=(l<0.5)?l*(1+s):l+s-l*s; p=2*l-q
        r=h2c(p,q,hh+1/3); g=h2c(p,q,hh); b=h2c(p,q,hh-1/3)
      }
      return sprintf("#%02x%02x%02x",int(r*255+0.5),int(g*255+0.5),int(b*255+0.5))
    }
    function hdist(x,y, d) { d=x-y; if(d<0)d=-d; if(d>180)d=360-d; return d }
    BEGIN {
      n=split(colors,C," ")
      best_d=9999
      for (i=1;i<=n;i++) {
        hex2hsl(C[i],H)
        d=hdist(H[0],target)
        if (d<best_d) { best_d=d; best_hex=C[i]; best_s=H[1]; best_l=H[2] }
      }
      if (best_d<=max_dist) {
        print best_hex
      } else {
        # No palette slot within tolerance — synthesise at target hue,
        # preserving the wallpaper palette'\''s saturation/lightness feel
        s=best_s; l=best_l
        if (s<0.35) s=0.60
        if (l<0.35) l=0.55
        if (l>0.75) l=0.65
        print hsl2hex(target,s,l)
      }
    }
  ' /dev/null)
  brighten_floor "$result" 220
}
```

- [ ] **Step 2: Smoke-test `pick_best_hue()` in isolation**

Source just the needed functions and test:

```bash
source ~/.config/rofi/theme-switcher.sh 2>/dev/null || true
cache="$HOME/.cache/theme-switcher/palette.json"
all_colors=$(jq -r '[.color0,.color1,.color2,.color3,.color4,.color5,
                     .color6,.color7,.color8,.color9,.color10,.color11,
                     .color12,.color13,.color14,.color15] | join(" ")' "$cache")

echo "BLUE    (target 220°): $(pick_best_hue "$all_colors" 220 60)"
echo "GREEN   (target 130°): $(pick_best_hue "$all_colors" 130 60)"
echo "PURPLE  (target 280°): $(pick_best_hue "$all_colors" 280 60)"
echo "MAGENTA (target 310°): $(pick_best_hue "$all_colors" 310 60)"
echo "PINK    (target 350°): $(pick_best_hue "$all_colors" 350 70)"
echo "CYAN    (target 190°): $(pick_best_hue "$all_colors" 190 60)"
```

Expected for current crimson/navy wallpaper:
- **BLUE**: hue ~180-260° — should pick `color2`/`color10`/`color13` (actual blues in palette)
- **GREEN**: hue ~100-160° — synthesised (no green in this palette); will be a vivid green using wallpaper's S/L
- **PURPLE**: hue ~250-310° — may pick `color6=#650552` (~295°) or synthesise
- **MAGENTA**: hue ~280-340° — similar to purple slot
- **PINK**: hue ~320-360° — should pick `color1`, `color9`, or `color12` (reds)
- **CYAN**: hue ~160-220° — should pick one of the blue slots (close enough to cyan)

A result outside the expected hue range = bug in the awk logic. Fix before proceeding.

- [ ] **Step 3: Commit**

```bash
git add ~/.config/rofi/theme-switcher.sh
git commit -m "feat: add pick_best_hue() for semantic hue-matched accent selection"
```

---

### Task 3: Refactor `extract_palette()` accent extraction

**Files:**
- Modify: `~/.config/rofi/theme-switcher.sh:204-250` (the `extract_palette` function body)

- [ ] **Step 1: Replace the jq read block**

Find and replace this block inside `extract_palette()`:

```bash
  # OLD — replace this entire block:
  local bg_main bg_zero c8 c7 fg_raw c12 c11 c14 c13 c10 c9 c5 c3 c4
  {
    read -r bg_main; read -r bg_zero
    read -r c8;      read -r c7;      read -r fg_raw
    read -r c12;     read -r c11;     read -r c14
    read -r c13;     read -r c10;     read -r c9
    read -r c5;      read -r c3;      read -r c4
  } < <(jq -r '.background, .color0, .color8, .color7, .foreground,
               .color12, .color11, .color14, .color13, .color10,
               .color9, .color5, .color3, .color4' "$cache")
```

Replace with:

```bash
  local bg_main bg_zero c8 c7 fg_raw all_colors
  {
    read -r bg_main; read -r bg_zero
    read -r c8;      read -r c7;      read -r fg_raw
    read -r all_colors
  } < <(jq -r '.background, .color0, .color8, .color7, .foreground,
               ([.color0,.color1,.color2,.color3,.color4,.color5,.color6,.color7,
                 .color8,.color9,.color10,.color11,.color12,.color13,.color14,.color15]
                | join(" "))' "$cache")
```

- [ ] **Step 2: Replace the accent assignment block**

Find and replace these lines inside `extract_palette()` (immediately after the BG/FG assignments):

```bash
  # OLD — replace these 9 lines:
  ACCENT_PINK=$(brighten_floor "$c12" 220)
  ACCENT_GREEN=$(brighten_floor "$c11" 220)
  ACCENT_BLUE=$(brighten_floor "$c14" 220)
  ACCENT_PURPLE=$(brighten_floor "$c13" 220)
  ACCENT_CYAN=$(brighten_floor "$c10" 220)
  ACCENT_LBLUE=$(brighten_floor "$c9" 220)
  ACCENT_MAGENTA=$(brighten_floor "$c5" 220)
  ACCENT_TEAL=$(brighten_floor "$c3" 220)
  ACCENT_SKY=$(brighten_floor "$c4" 220)
```

Replace with:

```bash
  # Accents: best-matching hue from the full 16-slot palette.
  # Hue targets are midpoints of each colour's semantic zone (degrees).
  # Tolerance 60°: slots within 60° are used as-is; further slots are
  # hue-rotated to the target while keeping wallpaper saturation/lightness.
  ACCENT_BLUE=$(pick_best_hue     "$all_colors" 220 60)
  ACCENT_LBLUE=$(pick_best_hue    "$all_colors" 210 60)
  ACCENT_PURPLE=$(pick_best_hue   "$all_colors" 280 60)
  ACCENT_TEAL=$(pick_best_hue     "$all_colors" 182 60)
  ACCENT_CYAN=$(pick_best_hue     "$all_colors" 190 60)
  ACCENT_MAGENTA=$(pick_best_hue  "$all_colors" 310 60)
  ACCENT_GREEN=$(pick_best_hue    "$all_colors" 130 60)
  ACCENT_SKY=$(pick_best_hue      "$all_colors" 205 60)
  ACCENT_PINK=$(pick_best_hue     "$all_colors" 350 70)
```

- [ ] **Step 3: Verify the validation block still works**

The existing validation loop that follows (checks for empty/null variables) uses the same variable names (`$ACCENT_BLUE`, etc.) — it requires no changes. Confirm it's still present and unmodified:

```bash
grep -n 'if.*-z.*c.*null.*load_oxocarbon' ~/.config/rofi/theme-switcher.sh
# Should show a line number — confirms the fallback guard is intact
```

- [ ] **Step 4: Commit**

```bash
git add ~/.config/rofi/theme-switcher.sh
git commit -m "refactor: replace fixed-slot accent mapping with hue-best-match selection

Accent colours now scan all 16 wallust palette slots for the closest
hue match rather than blindly using hardcoded slot numbers. For palettes
where a semantic hue doesn't exist (e.g. no green in a crimson wallpaper),
the closest slot's S/L is preserved while the hue is rotated to the
target zone. BG/FG extraction is unchanged."
```

---

### Task 4: End-to-end verification

**Files:**
- Read: `~/.config/rofi/colors.rasi` (after re-running theme-switcher)

- [ ] **Step 1: Run theme-switcher with current wallpaper**

```bash
~/.config/rofi/theme-switcher.sh
# In the rofi menu, select the current wallpaper to re-apply
```

- [ ] **Step 2: Inspect generated colors.rasi**

```bash
cat ~/.config/rofi/colors.rasi
```

Check these variables are no longer in the pink/magenta zone:

| Variable | Should be | Was |
|----------|-----------|-----|
| `r-blue` | blue hex (~180-260°) | `#dc09bb` magenta |
| `r-purple` | purple hex (~250-310°) | `#097bdc` blue |
| `r-teal` | teal hex (~160-210°) | `#0969dc` blue |
| `r-wp-accent` | pink/red hex (~320-360°) | `#dc083b` red ✓ |

- [ ] **Step 3: Open rofi launcher visually**

```bash
~/.config/rofi/launcher.sh
```

Element text (`@blue`) and borders should now render in blue/purple tones. If still pink, something in `generate_rofi_colors()` is reading an unexpected variable — double-check Task 3 Step 2 replaced all 9 lines.

- [ ] **Step 4: Test Oxocarbon fallback unaffected**

Run `~/.config/rofi/theme-switcher.sh` and select "Oxocarbon (Default)". The `load_oxocarbon()` path sets hardcoded values and never calls `pick_best_hue()`, so no regression expected. Colours should be identical to pre-change behaviour.

- [ ] **Step 5: Test with a cool-toned wallpaper (if available)**

```bash
ls ~/Pictures/wallpapers/
```

If you have a blue/green wallpaper: apply it, then open the launcher. Blues should stay blue (picked directly from palette, no synthesis needed). Pink/red accents like `ACCENT_PINK` should rotate away from blue on a cool wallpaper — verify they stay in the red-pink zone.

- [ ] **Step 6: Final commit**

```bash
git add ~/.config/rofi/colors.rasi
git commit -m "chore: regenerate colors.rasi with hue-anchored accent extraction"
```

---

## Tuning reference

| Parameter | Default | Effect |
|-----------|---------|--------|
| `max_dist` per accent | `60` (pink: `70`) | Tighten (e.g. `45`) → more synthesis, "correct" colours. Loosen (e.g. `75`) → more wallpaper-native colours, may drift |
| Synthesis S floor | `0.35 → 0.60` | Prevents washed-out synthesised accents on desaturated wallpapers |
| Synthesis L clamp | `0.35–0.75 → 0.55–0.65` | Keeps synthesised colours readable; adjust if they look too light/dark |
| `brighten_floor` target | `220` | Shared with original code; keeps all accents clearly visible on dark BGs |

**ACCENT_BLUE vs ACCENT_LBLUE overlap:** Both target ~210-220°. On most wallpapers both pick the same slot. `brighten_floor` will produce the same output, making them identical. This is harmless — the script uses them in different roles (e.g. active border vs. dim). If you want them visually distinct, set LBLUE's `max_dist` to `75` so it finds a second-closest candidate.
