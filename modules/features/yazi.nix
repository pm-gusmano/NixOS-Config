{ ... }: {
  den.aspects.yazi.homeManager.programs.yazi = {
    enable = true;
    shellWrapperName = "y";

    enableBashIntegration = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
  };
}
