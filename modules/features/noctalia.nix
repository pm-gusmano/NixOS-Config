{ self, inputs, ... }: {

  perSystem = { pkgs, ... }: {

    packages.myNoctalia = inputs.wrapper-modules.wrappers.noctalia-shell.wrap {
      pkgs = inputs.nixpkgs-noctalia.legacyPackages.${pkgs.stdenv.hostPlatform.system};
      settings =
        (builtins.fromJSON
	  (builtins.readFile ./noctalia.json)).settings;
    };

  };

}
