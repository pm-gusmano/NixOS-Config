{ self, inputs, den, ... }: {
  imports = [ inputs.den.flakeModule ];

  den.hosts.x86_64-linux.dellXps15.users."pm-gusmano".classes = [ "homeManager" ];

  den.aspects.dellXps15.includes = [ den.aspects.cursor ];

  den.aspects.dellXps15.nixos = {
    imports = [ self.nixosModules.dellXps15Configuration ];
    programs.zsh.enable = true;
    # Preserve existing user configuration when Home Manager takes ownership.
    home-manager.backupFileExtension = "before-home-manager";
  };

  den.aspects."pm-gusmano" = {
    includes = [ den.aspects.yazi den.aspects.cursor den.aspects.neovim ];

    homeManager = {
      home.stateVersion = "26.05";
      programs.bash.enable = true;
      programs.zsh.enable = true;
    };
  };
}
