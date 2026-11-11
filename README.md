# onon-themes

Example themes for [onon](https://github.com/Aethar01/onon), a quiet reader for the keyboard. Each one shows off a different part of the theme system, and its header comment says which.

| Theme | Look |
|---|---|
| [`brutalist`](./themes/brutalist/brutalist.lua) | Black lines, hard shadows and safety yellow. |
| [`halftone`](./themes/brutalist/halftone.lua) | Brutalist printed on a coarse screen of dots that grow toward the hard shadow. |
| [`gameboy`](./themes/gameboy/gameboy.lua) | The four greens of a 1989 handheld, with pixel corners. |
| [`lcd`](./themes/gameboy/lcd.lua) | Gameboy with the page behind each pane in big dithered pixels and a faint grid. |
| [`glass`](./themes/glass/glass.lua) | Frosted, translucent panes floating over the page. |
| [`liquid`](./themes/glass/liquid.lua) | Glass run through a shader: the page behind each pane blurred, bent at the rim and lit along its edge. |
| [`manuscript`](./themes/manuscript/manuscript.lua) | Iron-gall ink on vellum, with panels torn from the page. |
| [`vellum`](./themes/manuscript/vellum.lua) | Manuscript on calfskin: grain and fibres, the page faint and yellowed beneath, ink soaked into the edges. |
| [`phosphor`](./themes/phosphor/phosphor.lua) | The green-screen terminals of the 1980s. |
| [`crt`](./themes/phosphor/crt.lua) | Phosphor on a curved tube, with scanlines, bloom and a faint flicker. |
| [`synthwave`](./themes/synthwave/synthwave.lua) | Pink and cyan neon on deep violet. |
| [`vhs`](./themes/synthwave/vhs.lua) | Synthwave off a worn tape: colour fringing, a drifting tracking line and a neon rim. |
| [`vampire`](./themes/vampire/vampire.lua) | Blood on black, for reading after dark. |
| [`nosferatu`](./themes/vampire/nosferatu.lua) | Vampire with blood seeping in from the edges of each pane to a slow heartbeat. |

## Install

These themes need onon 0.14.10 or newer, which finds themes kept in folders of their own, as these are.

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

`liquid`, `crt`, `vhs`, `lcd`, `vellum`, `halftone` and `nosferatu` draw their panes with GLSL shaders. Shaders are experimental in onon, so turn them on in `config.lua` and restart onon:

```lua
onon.options.shaders = true
```

Without them `liquid` looks like `glass`, and the others like the theme in their folder, with see-through panes.

## Writing your own

The [theme guide](https://ononreader.com/docs/themes/) covers every field, element and drawing function. Copy one of these to start.

## License

[MIT](./LICENSE)
