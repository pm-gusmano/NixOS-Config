{
  description = "pm-gusmano's nixos configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";

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
