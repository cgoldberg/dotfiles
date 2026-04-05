# dconf settings

----

This directory contains exported `dconf` configuration/settings.

`dconf` is a low-level configuration system and settings management tool for
GNOME. It provides a back-end to GSettings (which depends on GIO/GLib).

Settings can be exported with `dconf dump` and restored with `dconf load`.

-----

## gnome-terminal

`gnome-terminal.properties` contains settings for `gnome-terminal`.

- generate new file with current settings:

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

`gnome-keybindings.properties` contains settings for keyboard keybindings.

- generate new file with current settings:

```
dconf dump /org/gnome/settings-daemon/plugins/media-keys/ > gnome-keybindings.properties
```

- restore settings:

```
dconf load /org/gnome/settings-daemon/plugins/media-keys/ < gnome-keybindings.properties
```
