{ ... }: {
  den.aspects.neovim.homeManager = { pkgs, ... }: {
    home.packages = [ pkgs.neovim ];
    home.sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
  };
}
