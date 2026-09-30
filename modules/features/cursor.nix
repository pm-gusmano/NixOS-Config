{ ... }:
let
  name = "Bibata-Modern-Classic";
  size = 24;
in
{
  den.aspects.cursor = {
    nixos = { pkgs, ... }: {
      environment.systemPackages = [ pkgs.bibata-cursors ];
      environment.sessionVariables = {
        XCURSOR_THEME = name;
        XCURSOR_SIZE = toString size;
      };
      services.displayManager.sddm.settings.Theme = {
        CursorTheme = name;
        CursorSize = size;
      };
    };

    homeManager = { pkgs, lib, ... }: {
      home.pointerCursor = {
        enable = true;
        package = pkgs.bibata-cursors;
        inherit name size;
        gtk.enable = true;
        x11.enable = true;
      };
      gtk.enable = true;

      # Change only Plasma's cursor keys, preserving other mouse settings.
      home.activation.bibataPlasma = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        run ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file kcminputrc --group Mouse --key cursorTheme ${name}
        run ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file kcminputrc --group Mouse --key cursorSize ${toString size}
      '';
    };
  };
}
