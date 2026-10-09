# dconf settings

----

This directory contains exported `dconf` configuration/settings.

`dconf` is a low-level configuration system and settings management tool for
GNOME. It provides a back-end to GSettings (which depends on GIO/GLib).

Settings can be exported with `dconf dump` and restored with `dconf load`.

-----

## gnome-terminal

- export current settings to file:

```
dconf dump /org/gnome/terminal/ > gnome-terminal.properties
 ```

- restore settings:

```
dconf load /org/gnome/terminal/ < gnome-terminal.properties
```

*Note: "UbuntuMono Nerd Font Mono" font is required.*

----

## keybindings

- shortcut types:
  - media keys and custom shortcuts
  - window manager shortcuts
  - gnome shell shortcuts

- export current settings to files:

```
dconf dump /org/gnome/settings-daemon/plugins/media-keys/ > gnome-media-keybindings.properties
dconf dump /org/gnome/desktop/wm/keybindings/ > gnome-wm-keybindings.properties
dconf dump /org/gnome/shell/keybindings/ > gnome-shell-keybindings.properties
```

- restore settings:

```
dconf load /org/gnome/settings-daemon/plugins/media-keys/ < gnome-media-keybindings.properties
dconf load /org/gnome/desktop/wm/keybindings/ < gnome-wm-keybindings.properties
dconf load /org/gnome/shell/keybindings/ < gnome-shell-keybindings.properties
```
