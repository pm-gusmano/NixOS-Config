# Overwatch on the Dell XPS 15

The Intel GPU drives the desktop. The RTX 4060 Laptop GPU runs Overwatch through
NVIDIA PRIME offload. The configuration includes NVIDIA's stable driver,
64-bit and 32-bit graphics libraries, and zstd compressed swap sized at 25% of
RAM (about 8 GiB). Zram reduces the risk of out-of-memory termination; it does
not fix driver or game bugs.

## Activate and reboot

```sh
cd /home/pm-gusmano/NixOS-Config
sudo nixos-rebuild switch --flake .#dellXps15
```

Save your work and reboot. A switch alone cannot replace the Nouveau driver
already bound to the GPU or change the running kernel. Keep the previous boot
generation available for recovery.

## Verify after reboot

```sh
nvidia-smi
lspci -nnk -s 01:00.0
nvidia-offload vulkaninfo --summary
swapon --show
```

Expected: RTX 4060 in `nvidia-smi`, `Kernel driver in use: nvidia`, the NVIDIA
GPU in the offloaded Vulkan summary, and `/dev/zram0` in the swap list. Both
`/run/opengl-driver/lib/libGLX_nvidia.so.0` and
`/run/opengl-driver-32/lib/libGLX_nvidia.so.0` should exist.

## Steam

Keep the installed Proton Hotfix initially (observed version:
`hotfix-20261001-x86_64`). Overwatch's per-game launch options are:

```text
/run/current-system/sw/bin/overwatch-launch %command%
```

The launcher checks that NVIDIA is loaded, sets
`DXVK_CONFIG="dxvk.trackPipelineLifetime = True"`, and runs `nvidia-offload`.
Pipeline lifetime tracking reduces memory retained by DX11 pipeline libraries.
It does not affect the DX12 renderer and is not a universal crash fix.

Steam settings were backed up beside `localconfig.vdf` before editing. Always
exit Steam before changing or restoring that file.

## First game session

Finish downloading the game and use Steam's Verify integrity of game files if
the download reports errors. The built-in panel is 1920x1200; start at that
resolution, 100% render scale, Medium graphics and textures, and a 120 FPS cap
(or lower if sustained performance warrants it). Use AC power.

Start with DX11. Let shader compilation settle, then test different heroes and
maps in the practice range and several unranked matches for at least 30–60
minutes. Confirm the Overwatch process appears in `nvidia-smi`. Watch system
memory and temperatures. These settings are an initial baseline, not a tested
optimum for this laptop.

If DX11 crashes, compare the latest stable Proton with the same settings.
Test DX12 separately if necessary and check that hero and weapon models render
correctly. Change one setting at a time. Avoid adding overlays or unrelated
environment flags until the baseline is stable.

For a reproducible crash, temporarily set launch options to:

```text
PROTON_LOG=1 /run/current-system/sw/bin/overwatch-launch %command%
```

The Proton log normally appears as `~/steam-2357570.log`. Disable logging after
the test because logs can become large. Check kernel and OOM errors with:

```sh
journalctl -b -k --no-pager | rg -i 'NVRM|Xid|out of memory|oom'
journalctl -b -u systemd-oomd --no-pager
```

## References

- [Valve's Proton version guidance](https://github.com/ValveSoftware/Proton/wiki/Proton-Versions)
- [DXVK pipeline lifetime documentation](https://github.com/doitsujin/dxvk/blob/master/dxvk.conf)
- [Overwatch NVIDIA memory report](https://github.com/doitsujin/dxvk/issues/3813)
- [Overwatch DX11 crashes and DX12 model report](https://github.com/ValveSoftware/Proton/issues/9977)

The reports document issues on other systems. Match stability on this machine
has not yet been verified.
