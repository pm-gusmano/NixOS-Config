# Neovim

Run from the repository with `nix run .#neovim`. Once these files are committed
and pushed, use `nix run github:pm-gusmano/NixOS-Config#neovim` on any supported
system. The `den.aspects.neovim` aspect installs this same package through either
its NixOS or Home Manager class. The existing user aspect already includes it.

The current nixpkgs input supports x86_64-linux, aarch64-linux, and
aarch64-darwin. The flake also lists x86_64-darwin, but its nixpkgs version has
dropped that platform; Intel macOS requires a compatible nixpkgs input.

`config/` contains the Neovim dotfiles copied from `~/dotfiles/nvim/.config/nvim`.
Edit the Lua files here to change the packaged configuration. The original
keymaps, autosave, theme, extras, ALE3D file detection, and Python search paths
are preserved. Those Python paths still refer to the original local projects;
the projects and Cubit installation are not included in the package.

`plugins.json` pins every plugin to its original `lazy-lock.json` revision and
Nix source hash. Lazy handles loading and configuration, with Nix store paths
for every plugin. Runtime plugin installation, updates, project plugin specs,
LuaRocks, Mason, and parser installation are disabled. Plugin updates must be
made in Nix rather than through `:Lazy update` or `:Mason`.

Nix builds Blink's Rust library, Markdown preview's Node dependencies, and the
Tree-sitter parsers. Parser versions and language servers/formatters follow the
flake's locked nixpkgs; plugin Lua versions follow `plugins.json`. `lazy.lua`
provides the small Nix integration layer instead of the original Git bootstrap.
Caches and state use the separate `pm-neovim` application name; no files need to
be installed under `~/.config/nvim`.

Run `nix build .#checks.x86_64-linux.neovim` for the sandboxed startup check.
This verifies configuration, plugin paths, native completion, parsers, tools,
and file detection with an empty home and no network access.
