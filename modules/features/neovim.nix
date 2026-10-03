{ self, ... }: {
  perSystem = { pkgs, self', ... }: {
    packages.neovim = pkgs.callPackage ../../packages/neovim {};
    apps.neovim = {
      type = "app";
      program = "${self'.packages.neovim}/bin/nvim";
      meta.description = "Neovim with pm-gusmano's Nix-managed LazyVim dotfiles";
    };
    checks.neovim = pkgs.runCommand "neovim-dotfiles-check" {
      nativeBuildInputs = [ self'.packages.neovim ];
    } ''
      export HOME="$TMPDIR/home"
      export XDG_CONFIG_HOME="$HOME/.config"
      export XDG_DATA_HOME="$HOME/.local/share"
      export XDG_STATE_HOME="$HOME/.local/state"
      export XDG_CACHE_HOME="$HOME/.cache"
      mkdir -p "$HOME"
      nvim --headless -i NONE \
        --cmd 'lua _G.neovim_check_errors = {}; vim.notify = function(msg, level) if level == vim.log.levels.ERROR then table.insert(_G.neovim_check_errors, msg) end end' \
        -c 'lua dofile("${../../packages/neovim/check.lua}")'
      test -z "$(ls -A "$XDG_DATA_HOME/pm-neovim/lazy")"
      test ! -d "$XDG_DATA_HOME/pm-neovim/mason"
      touch "$out"
    '';
  };

  den.aspects.neovim = {
    nixos = { pkgs, ... }: {
      environment.systemPackages = [ self.packages.${pkgs.stdenv.hostPlatform.system}.neovim ];
      environment.variables = { EDITOR = "nvim"; VISUAL = "nvim"; };
    };
    homeManager = { pkgs, ... }: {
      home.packages = [ self.packages.${pkgs.stdenv.hostPlatform.system}.neovim ];
      home.sessionVariables = { EDITOR = "nvim"; VISUAL = "nvim"; };
    };
  };
}
