# dconf settings

----

This directory contains exported `dconf` configuration/settings.

`dconf` is a low-level configuration system and settings management tool for
GNOME. It provides a back-end to GSettings (which depends on GIO/GLib).

Settings can be exported with `dconf dump` and restored with `dconf load`.

-----

## gnome-terminal

`gnome-terminal.properties` contains settings for `gnome-terminal`.

- #### generate a new file with current settings:

```
dconf dump /org/gnome/terminal/ > gnome-terminal.properties
 ```

* #### restore these settings:

```
cat gnome-terminal.properties | dconf load /org/gnome/terminal/
```

*Note: "Ubuntu Mono" font requires the `fonts-ubuntu` package.*

----
