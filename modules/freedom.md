# Freedom filtering

`configuration.nix` imports `freedom.nix`. The root flake imports the Steven
Black module and pins its blocklists in `flake.lock`, following the existing
nixpkgs input. Pornography, gambling, and social-media blocking are enabled.

The module declares a static CleanBrowsing Family DNS configuration for IPv4
and IPv6, prevents NetworkManager and DHCP from replacing it, and restricts
outbound DNS to those servers. It blocks TCP and UDP port 853 and locks Firefox's
DNS-over-HTTPS and proxy settings. The firewall applies to traffic originating
on this host, not traffic forwarded for containers or virtual machines.

Build and apply from the repository root:

```sh
nixos-rebuild build --flake .#nixos
sudo nixos-rebuild switch --flake .#nixos
```

After switching, restart Firefox and check `about:policies` for active policies
without errors. Inspect `cat /etc/resolv.conf` for only the declared servers,
run `getent hosts nixos.org` to check ordinary resolution, and inspect
`sudo nft list table inet freedom` for the outbound rules. Follow
[CleanBrowsing's verification instructions](https://cleanbrowsing.org/getting-started)
to verify filtering without visiting explicit content.
Repeat the DNS check after reconnecting to a network.

To update the pinned blocklist, run `nix flake update hosts`, then rebuild.
This deliberately does not update nixpkgs.

Filtering is friction, not a guarantee. Administrator access can change these
settings; other browsers, HTTPS tunnels, and other devices need their own
controls. For stronger friction, arrange a separate administrator account with
someone you trust, verify their access, and only then remove administrator
privileges from your daily account. No account privileges are changed here.

Family filtering also restricts some mixed-content sites, and the social
blocklist can block sites you use normally. Networks that require their own
DNS (including some captive portals and work VPNs) may fail to resolve names;
there is intentionally no unfiltered DNS fallback.

References: [CleanBrowsing filters](https://cleanbrowsing.org/filters),
[Steven Black hosts](https://github.com/StevenBlack/hosts), and
[Firefox policies](https://mozilla.github.io/policy-templates/).
