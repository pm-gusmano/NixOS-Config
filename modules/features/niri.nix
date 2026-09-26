{self, inputs, ... }: {

  flake.nixosModules.niri = { pkgs, lib, ... }: {
    services.displayManager.defaultSession = lib.mkForce "niri";

    programs.niri = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.myNiri;
    };
  };

  perSystem = {pkgs, lib, self', ...}: {

    packages.myNiri = inputs.wrapper-modules.wrappers.niri.wrap {
      inherit pkgs;

      settings = {
        spawn-at-startup = [
          (lib.getExe self'.packages.myNoctalia)
        ];
        input.keyboard.xkb = {
          layout = "us";
          variant = "colemak_dh";
        };

	xwayland-satellite.path =
	  lib.getExe pkgs.xwayland-satellite;

        binds = {
          "Mod+Return".spawn = "${pkgs.ghostty}/bin/ghostty";
          "Mod+Space".spawn = [
            (lib.getExe self'.packages.myNoctalia)
            "ipc" "call" "launcher" "toggle"
          ];

          # Colemak-DH right-hand navigation: left, down, up, right.
          "Mod+M".focus-column-left = _: {};
          "Mod+N".focus-window-down = _: {};
          "Mod+E".focus-window-up = _: {};
          "Mod+I".focus-column-right = _: {};

          # Ctrl moves the column horizontally or the window vertically.
          "Mod+Ctrl+M".move-column-left = _: {};
          "Mod+Ctrl+N".move-window-down = _: {};
          "Mod+Ctrl+E".move-window-up = _: {};
          "Mod+Ctrl+I".move-column-right = _: {};

          # Shift targets workspaces; Ctrl moves the window there.
          "Mod+Shift+N".focus-workspace-down = _: {};
          "Mod+Shift+E".focus-workspace-up = _: {};
          "Mod+Ctrl+Shift+N".move-window-to-workspace-down = _: {};
          "Mod+Ctrl+Shift+E".move-window-to-workspace-up = _: {};

          "Mod+Q".close-window = _: {};
          "Mod+R".switch-preset-column-width = _: {};
          "Mod+F".maximize-column = _: {};
          "Mod+Shift+F".fullscreen-window = _: {};
          "Mod+Shift+Slash".show-hotkey-overlay = _: {};
        };
      };
    };

  };

}
