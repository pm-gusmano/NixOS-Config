{ ... }: {
  den.aspects.navigation.homeManager = { pkgs, ... }: {
    home.packages = [ pkgs.fd pkgs.bat pkgs.eza ];

    programs.zoxide = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };

    programs.fzf = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;

      # Include dotfiles, while respecting ignore files and excluding Git internals.
      defaultCommand = "${pkgs.fd}/bin/fd --type f --hidden --exclude .git";
      defaultOptions = [ "--height=40%" "--layout=reverse" "--border" ];

      fileWidget = {
        command = "${pkgs.fd}/bin/fd --type f --type d --hidden --exclude .git";
        options = [
          "--preview 'if [ -d {} ]; then ${pkgs.eza}/bin/eza --color=always --all -- {}; else ${pkgs.bat}/bin/bat --color=always --style=numbers --line-range=:200 -- {}; fi'"
          "--bind 'ctrl-/:toggle-preview'"
        ];
      };

      changeDirWidget = {
        command = "${pkgs.fd}/bin/fd --type d --hidden --exclude .git";
        options = [ "--preview '${pkgs.eza}/bin/eza --color=always --all -- {}'" ];
      };
    };
  };
}
