{...}:

{

  flake.nixosModules.yazi = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.yazi ];


  }

}
