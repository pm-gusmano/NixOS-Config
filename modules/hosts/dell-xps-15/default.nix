{self, inputs, ... }: {

  flake.nixosConfigurations.dellXps15 = inputs.nixpkgs.lib.nixosSystem {
    modules = [];
  };
}
