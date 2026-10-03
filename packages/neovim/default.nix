{ pkgs, lib ? pkgs.lib }:
let
  pins = builtins.fromJSON (builtins.readFile ./plugins.json);
  sources = lib.mapAttrs (_: pin: pkgs.fetchzip {
    url = "https://codeload.github.com/${pin.owner}/${pin.repo}/tar.gz/${pin.rev}";
    inherit (pin) hash;
    extension = "tar.gz";
  }) pins;
  fuzzy = pkgs.rustPlatform.buildRustPackage {
    pname = "blink-cmp-fuzzy";
    version = pins."blink.cmp".rev;
    src = sources."blink.cmp";
    cargoHash = "sha256-z8koRYVM9mkgKB6rdZAKIfjZfinVUUpYAW0IvPgmjZ4=";
    nativeBuildInputs = [ pkgs.gitMinimal ];
    env = {
      RUSTC_BOOTSTRAP = true;
      RUSTFLAGS = lib.optionalString pkgs.stdenv.hostPlatform.isDarwin
        "-C link-arg=-undefined -C link-arg=dynamic_lookup";
    };
  };
  plugins = lib.mapAttrs (name: pin: pkgs.vimUtils.buildVimPlugin {
    pname = name;
    version = pin.rev;
    src = sources.${name};
    # LazyVim configures these plugins together at runtime.
    doCheck = false;
    postInstall = lib.optionalString (name == "blink.cmp") ''
      mkdir -p $out/target/release
      ln -s ${fuzzy}/lib/libblink_cmp_fuzzy${pkgs.stdenv.hostPlatform.extensions.sharedLibrary} $out/target/release/
    '' + lib.optionalString (name == "markdown-preview.nvim") ''
      ln -s ${pkgs.vimPlugins.markdown-preview-nvim}/app/node_modules $out/app/node_modules
    '';
  }) pins;
  pluginPaths = lib.mapAttrs (_: plugin: toString plugin) plugins;
  languages = [
    "bash" "c" "diff" "html" "javascript" "jsdoc" "json" "json5"
    "lua" "luadoc" "luap" "markdown" "markdown_inline" "ninja" "printf"
    "python" "query" "regex" "rst" "toml" "tsx" "typescript" "vim"
    "vimdoc" "xml" "yaml"
  ];
  parsers = pkgs.symlinkJoin {
    name = "neovim-treesitter-parsers";
    paths = map (lang: pkgs.vimPlugins.nvim-treesitter.parsers.${lang}) languages;
  };
  treesitterSite = pkgs.runCommand "neovim-treesitter-site" {} ''
    mkdir -p $out
    ln -s ${parsers}/parser $out/parser
    ln -s ${plugins."nvim-treesitter"}/runtime/queries $out/queries
  '';
  config = pkgs.runCommand "neovim-config" {} ''
    mkdir -p $out
    cp -r ${./config}/. $out/
    chmod -R u+w $out
    substitute ${./lazy.lua} $out/lua/config/lazy.lua \
      --replace-fail '@pluginPaths@' '${builtins.toJSON pluginPaths}' \
      --replace-fail '@treesitterSite@' '${treesitterSite}'
  '';
  tools = with pkgs; [
    git jujutsu lazygit ripgrep fd fzf curl unzip nodejs
    lua-language-server stylua shfmt shellcheck
    pyright basedpyright ruff python3Packages.debugpy
    vscode-langservers-extracted marksman markdownlint-cli2 prettier taplo just just-lsp
  ] ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [ wl-clipboard xclip ];
in
(pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped {
  withPython3 = true;
  withNodeJs = true;
  extraPython3Packages = ps: [ ps.pynvim ps.pytest ];
  wrapperArgs = [
    "--set" "NVIM_APPNAME" "pm-neovim"
    "--prefix" "PATH" ":" (lib.makeBinPath tools)
  ];
  luaRcContent = ''
    local config = "${config}"
    vim.opt.rtp:prepend(config)
    vim.g.lazyvim_json = config .. "/lazyvim.json"
    vim.g.pm_neovim_config = config
    require("config.lazy")
  '';
}).overrideAttrs (old: {
  passthru = old.passthru // { inherit plugins config treesitterSite; };
})
