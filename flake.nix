{
  description = "pm-gusmano's nixos configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # Keep Noctalia and its runtime on the working system's package set
    # until the Breakpad build failure is fixed in nixos-unstable.
    nixpkgs-noctalia.url = "github:NixOS/nixpkgs/e554fab72f81915600f3f449b786fd9af40439a5";
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
    den.url = "github:denful/den";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wrapper-modules.url = "github:BirdeeHub/nix-wrapper-modules";
    hosts = {
      url = "github:StevenBlack/hosts";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # import modules/ automatically
  outputs = inputs: inputs.flake-parts.lib.mkFlake 
    {inherit inputs;}
    (inputs.import-tree ./modules);
}
