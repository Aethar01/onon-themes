<div align="center">

# onon-themes

**Example themes for [onon](https://github.com/Aethar01/onon).**

Eight themes exploring palettes, Lua shape functions, custom draw hooks, liquid motion and experimental GLSL shaders.

[onon](https://github.com/Aethar01/onon) · [Theme guide](https://ononreader.com/docs/themes/) · [Plugins](https://github.com/Aethar01/onon-plugins) · [Website](https://ononreader.com/)

</div>

<br />

<p align="center">
  <img src="https://ononreader.com/screenshots/themes/preview.webp" alt="Live :theme preview cycling through brutalist, forest-rain, gameboy, glass, manuscript, phosphor, synthwave and vampire with GPU shaders enabled" width="100%" />
</p>

## Themes

<table>
  <tr>
    <td width="50%" align="center" valign="top">
      <img src="https://ononreader.com/screenshots/themes/brutalist.png" alt="brutalist theme on the EHT M87* paper" width="100%" />
      <br />
      <sub><strong><a href="./themes/brutalist/brutalist.lua">brutalist</a></strong> · <a href="./themes/brutalist/brutalist.glsl">shader</a><br />Black frames, hard offset shadows, safety yellow and a coarse halftone dot screen. <code>:colors alt</code> inverts everything, pages included.</sub>
    </td>
    <td width="50%" align="center" valign="top">
      <img src="https://ononreader.com/screenshots/themes/forest-rain.png" alt="forest-rain theme on the EHT M87* paper" width="100%" />
      <br />
      <sub><strong><a href="./themes/forest-rain/forest-rain.lua">forest-rain</a></strong> · <a href="./themes/forest-rain/forest-rain.glsl">shader</a><br />Pine, moss and ember: a warm cabin window with beads of rain running down the glass. Shown in <code>:colors alt</code>.</sub>
    </td>
  </tr>
  <tr>
    <td width="50%" align="center" valign="top">
      <img src="https://ononreader.com/screenshots/themes/gameboy.png" alt="gameboy theme in alternate colours on the EHT M87* paper" width="100%" />
      <br />
      <sub><strong><a href="./themes/gameboy/gameboy.lua">gameboy</a></strong> · <a href="./themes/gameboy/gameboy.glsl">shader</a><br />The four greens of a 1989 handheld, stair-stepped pixel corners, an RPG cursor and an ordered-dithered LCD shader. Shown in <code>:colors alt</code>.</sub>
    </td>
    <td width="50%" align="center" valign="top">
      <img src="https://ononreader.com/screenshots/themes/glass.png" alt="glass theme on the EHT M87* paper" width="100%" />
      <br />
      <sub><strong><a href="./themes/glass/glass.lua">glass</a></strong> · <a href="./themes/glass/glass.glsl">shader</a> · <a href="./themes/glass/glass-selected.glsl">selection shader</a><br />Frosted, translucent panes with lens-bent rims, a rim-lit bead of glass for the selection and liquid spring motion. <code>:colors alt</code> shifts to night glass.</sub>
    </td>
  </tr>
  <tr>
    <td width="50%" align="center" valign="top">
      <img src="https://ononreader.com/screenshots/themes/manuscript.png" alt="manuscript theme in alternate sepia colours on the EHT M87* paper" width="100%" />
      <br />
      <sub><strong><a href="./themes/manuscript/manuscript.lua">manuscript</a></strong> · <a href="./themes/manuscript/manuscript.glsl">shader</a><br />Iron-gall ink on vellum with Lua-torn paper edges, rubric red headings and a hand-drawn underline. Shown in <code>:colors alt</code> sepia lamplight.</sub>
    </td>
    <td width="50%" align="center" valign="top">
      <img src="https://ononreader.com/screenshots/themes/phosphor.png" alt="phosphor theme in alternate green-screen colours on the EHT M87* paper" width="100%" />
      <br />
      <sub><strong><a href="./themes/phosphor/phosphor.lua">phosphor</a></strong> · <a href="./themes/phosphor/phosphor.glsl">shader</a><br />1980s green-screen terminal with scanlines, inverse-video selection, a block cursor and bulging CRT bloom. Shown in <code>:colors alt</code>.</sub>
    </td>
  </tr>
  <tr>
    <td width="50%" align="center" valign="top">
      <img src="https://ononreader.com/screenshots/themes/synthwave.png" alt="synthwave theme in alternate neon colours on the EHT M87* paper" width="100%" />
      <br />
      <sub><strong><a href="./themes/synthwave/synthwave.lua">synthwave</a></strong> · <a href="./themes/synthwave/synthwave.glsl">shader</a><br />Hot pink and cyan neon on deep violet, spring easings, chromatic aberration and a drifting VHS tracking line. Shown in <code>:colors alt</code>.</sub>
    </td>
    <td width="50%" align="center" valign="top">
      <img src="https://ononreader.com/screenshots/themes/vampire.png" alt="vampire theme in alternate crypt-dark colours on the EHT M87* paper" width="100%" />
      <br />
      <sub><strong><a href="./themes/vampire/vampire.lua">vampire</a></strong> · <a href="./themes/vampire/vampire.glsl">shader</a><br />Blood on black with gothic panels, coffin status pills and tabs, a dripping selection ribbon and a heartbeat blood-seep shader. Shown in <code>:colors alt</code>.</sub>
    </td>
  </tr>
</table>

<p align="center">
  <sub>
    Screenshots captured with <code>onon.options.shaders = true</code>. Document shown:
    <a href="https://arxiv.org/abs/1906.11238">EHT Collaboration (2019)</a> (CC BY 3.0).
  </sub>
</p>

## What each theme shows

Each theme doubles as a worked example of part of onon's theme API (its header comment lists the specifics):

| Theme | `:colors alt` | Theme features demonstrated |
|---|---|---|
| [`brutalist`](./themes/brutalist/brutalist.lua) | Full inversion, pages included | Unblurred offset shadows, per-side borders, fixed vs palette colours, stepping motion, halftone shader |
| [`forest-rain`](./themes/forest-rain/forest-rain.lua) | Dark pages read by the fire | Animated raindrop window shader, leaf-cut SVG hints, `canvas:path()` raindrops & puddle loader, falling motion |
| [`gameboy`](./themes/gameboy/gameboy.lua) | Pages on the 4-green LCD | Fixed 4-colour palette, Lua shape functions for pixel corners, bitmap pixel-art loader, ordered-dither shader |
| [`glass`](./themes/glass/glass.lua) | Frosted night glass | Translucent fills, shared spring & stretch motion, reduced-motion crossfades, lens-refraction & bead selection shaders |
| [`manuscript`](./themes/manuscript/manuscript.lua) | Sepia lamplight pages | Lua-computed torn edges, strokes, serif font styling, wiping underline selection, vellum fibre shader |
| [`phosphor`](./themes/phosphor/phosphor.lua) | Pages burned into phosphor green | Monospace fonts, block cursor element, `canvas:text` draw functions, motion disabled, CRT bloom & flicker shader |
| [`synthwave`](./themes/synthwave/synthwave.lua) | Cyan accent on violet pages | Layered neon shadows, Lua-mixed gradient rules, overshooting bezier & spring easings, animated sunset loader, VHS shader |
| [`vampire`](./themes/vampire/vampire.lua) | Parchment ink on near-black | Custom SVG path shapes (gothic panels, coffin pills, fanged hints), glowing shadows, dripping ribbon & bleeding loader, heartbeat shader |

## Installation

These themes require **onon 0.14.19** (or latest `main`), which adds theme subdirectories, shader detection, tab/hover/document/stretch/press motion and `link_preview` padding.

<details open>
<summary><strong>Linux &amp; macOS</strong></summary>

Clone the repository into your onon config directory and link `themes` beside it:

```bash
git clone https://github.com/Aethar01/onon-themes ~/.config/onon/onon-themes
ln -s onon-themes/themes ~/.config/onon/themes
```

Run `git pull` in `~/.config/onon/onon-themes` to update, then `:reload-config` inside onon. If you already have a `themes` directory, copy the individual theme folders you want into it instead.

</details>

<details>
<summary><strong>Windows</strong></summary>

Clone the repository and copy the theme folders into `%APPDATA%\onon\themes`:

```powershell
git clone https://github.com/Aethar01/onon-themes "$env:APPDATA\onon\onon-themes"
New-Item -ItemType Directory -Force "$env:APPDATA\onon\themes"
Copy-Item -Recurse "$env:APPDATA\onon\onon-themes\themes\*" "$env:APPDATA\onon\themes"
```

</details>

## Usage

Open the picker with `:theme` to preview each installed theme live as you move through the list, and press `Enter` to keep your choice. You can also switch directly by name:

```
:theme forest-rain
```

Toggle each theme's alternate colour mode with `Ctrl-R` (or `:colors alt`).

### Experimental GLSL shaders

Every theme includes a matching `.glsl` shader for its menus, status pill, tabs and link previews (`glass` adds a second shader for its selected row and tab). Shaders are experimental in onon — enable them in `config.lua` and restart:

```lua
onon.options.shaders = true
```

Without shaders enabled, every theme renders cleanly with its Lua styles and draw functions alone.

## Writing your own

The [theme guide](https://ononreader.com/docs/themes/) documents every palette key, element, shape helper, draw function and shader uniform. Any folder in [`themes/`](./themes) is small enough to copy as a starting point.

## License

[MIT](./LICENSE)
