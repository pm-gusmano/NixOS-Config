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
        cursor = {
          xcursor-theme = "Bibata-Modern-Classic";
          xcursor-size = 24;
        };

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
          "Mod+O".toggle-overview = _: {};
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

          # Like Zellij's Alt+F: switch focus between floating and tiled panes.
          # Shift changes the focused window's layout instead of its focus.
          "Mod+F".switch-focus-between-floating-and-tiling = _: {};
          "Mod+Shift+F".toggle-window-floating = _: {};

          # Stack/unstack toward a neighboring column; toggle its tabbed view.
          "Mod+Shift+M".consume-or-expel-window-left = _: {};
          "Mod+Shift+I".consume-or-expel-window-right = _: {};
          "Mod+T".toggle-column-tabbed-display = _: {};
          "Mod+C".center-window = _: {};
          "Mod+Tab".focus-workspace-previous = _: {};

          # Resize with the same directions, for both tiled and floating windows.
          "Mod+Alt+M".set-window-width = "-10%";
          "Mod+Alt+I".set-window-width = "+10%";
          "Mod+Alt+N".set-window-height = "+10%";
          "Mod+Alt+E".set-window-height = "-10%";
          "Mod+Shift+R".reset-window-height = _: {};

          "Mod+Q".close-window = _: {};
          "Mod+R".switch-preset-window-width = _: {};
          # Z for zoom; Shift gives the window the whole screen.
          "Mod+Z".maximize-column = _: {};
          "Mod+Shift+Z".fullscreen-window = _: {};
          "Mod+Shift+Slash".show-hotkey-overlay = _: {};
        };
      };
    };

  };

}
