# quickshell-island
Dynamic floating island in quickshell for Hyprland. Ships with gruvbox, but is compatible with any theme thanks to a generic palette. <br> <br>

The following command needs to be run to access the Control Center Home. 
```sh
qs ipc call controlCenter toggle
```
I'd recommend adding it as a hyprland binding. For example, adding the following to your ```hyprland.lua``` will open the control center home with ```SUPER + H```.
```lua
hl.bind(mainMod .. " + H", hl.dsp.exec_cmd("qs ipc call controlCenter toggle"))
```

You need to symlink the repo to ```~/.config/quickshell``` to be able to access the updates.
```sh
ln -s quickshell-island/ ~/.config/quickshell
```

## Configuration
The code itself is self documenting ™, but comments are available. Configuration can be done in the ```Config``` directory. The shell assumes kitty as terminal. Editing the ```qmldir``` in ```Connfig/``` handles changing of themes (dynamic theme switching will be implemented at a later date)

## Things to add
- Dynamic theme switching (backend)
- Dynamic theme switching (frontend)
