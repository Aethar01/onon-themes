# onon-themes

Example themes for [onon](https://github.com/Aethar01/onon), a quiet reader for the keyboard. Each one shows off a different part of the theme system, and its header comment says which.

| Theme | Look |
|---|---|
| [`brutalist`](./themes/brutalist.lua) | Black lines, hard shadows and safety yellow. |
| [`gameboy`](./themes/gameboy.lua) | The four greens of a 1989 handheld, with pixel corners. |
| [`glass`](./themes/glass.lua) | Frosted, translucent panes floating over the page. |
| [`manuscript`](./themes/manuscript.lua) | Iron-gall ink on vellum, with panels torn from the page. |
| [`phosphor`](./themes/phosphor.lua) | The green-screen terminals of the 1980s. |
| [`synthwave`](./themes/synthwave.lua) | Pink and cyan neon on deep violet. |
| [`vampire`](./themes/vampire.lua) | Blood on black, for reading after dark. |

## Install

Clone the repository into your onon directory and link its `themes` directory beside it:

```bash
git clone https://github.com/Aethar01/onon-themes ~/.config/onon/onon-themes
ln -s onon-themes/themes ~/.config/onon/themes
```

That works on Linux and macOS. `git pull` in the clone updates the themes, and `:reload-config` picks them up. If you already have a `themes` directory, copy in the `.lua` files you want instead.

On Windows, copy them out of the clone:

```powershell
git clone https://github.com/Aethar01/onon-themes "$env:APPDATA\onon\onon-themes"
New-Item -ItemType Directory -Force "$env:APPDATA\onon\themes"
Copy-Item -Recurse "$env:APPDATA\onon\onon-themes\themes\*" "$env:APPDATA\onon\themes"
```

## Use

`:theme` lists these themes beside the built-in ones and previews each as you move to it. <kbd>Enter</kbd> keeps the one selected. To pick one by name:

```
:theme vampire
```

Each one also has an alternate colour mode, which `:colors alt` turns on.

## Writing your own

The [theme guide](https://ononreader.com/docs/themes/) covers every field, element and drawing function. Copy one of these to start.

## License

[MIT](./LICENSE)
