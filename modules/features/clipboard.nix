{ ... }: {
  den.aspects.clipboard.homeManager = { pkgs, ... }: {
    home.packages = [ pkgs.wl-clipboard ];

    home.shellAliases = {
      clip = "${pkgs.wl-clipboard}/bin/wl-copy";
      clippaste = "${pkgs.wl-clipboard}/bin/wl-paste";
    };

    programs.fzf.historyWidget.options = [
      "--bind 'ctrl-y:execute-silent(printf %s {2..} | ${pkgs.wl-clipboard}/bin/wl-copy)+abort'"
      "--header 'Ctrl-Y: copy command to clipboard'"
    ];
  };
}
