{ inputs, ... }: {
  flake.nixosModules.freedom = { config, lib, ... }:

    let
      familyIPv4 = [ "185.228.168.168" "185.228.169.168" ];
      familyIPv6 = [ "2a0d:2a00:1::" "2a0d:2a00:2::" ];
    in
    {
      imports = [ inputs.hosts.nixosModule ];

      # Extra local blocklists
      networking.stevenBlackHosts = {
        enable = true;
        blockPorn = true;
        blockGambling = true;
        blockSocial = true;
      };

      # Use only CleanBrowsing Family Filter, including after changing networks.
      networking.nameservers = familyIPv4 ++ familyIPv6;
      networking.networkmanager.dns = "none";
      networking.dhcpcd.extraConfig = "nohook resolv.conf";
      networking.resolvconf.enable = false;
      services.resolved.enable = false;
      environment.etc."resolv.conf".text = lib.concatMapStrings
        (server: "nameserver ${server}\n") config.networking.nameservers;

      # Restrict outbound DNS for both address families. HTTPS-based DNS and
      # tunnels require additional controls; port filtering cannot identify them.
      networking.nftables = {
        enable = true;
        tables.freedom = {
          family = "inet";
          content = ''
            chain output {
              type filter hook output priority 0; policy accept;
              ip daddr { ${lib.concatStringsSep ", " familyIPv4} } meta l4proto { tcp, udp } th dport 53 accept
              ip6 daddr { ${lib.concatStringsSep ", " familyIPv6} } meta l4proto { tcp, udp } th dport 53 accept
              meta l4proto { tcp, udp } th dport { 53, 853 } reject with icmpx type admin-prohibited
            }
          '';
        };
      };

      # Prevent Firefox from bypassing the system DNS configuration.
      programs.firefox.policies = {
        DNSOverHTTPS = {
          Enabled = false;
          Locked = true;
        };
        Proxy = {
          Mode = "none";
          Locked = true;
        };
      };
  };
}
