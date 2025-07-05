[![Build & Package](https://github.com/MageJohn/steam-deck-gc-adapter/actions/workflows/build.yaml/badge.svg)](https://github.com/MageJohn/steam-deck-gc-adapter/actions/workflows/build.yaml)

# GameCube adapter driver for Steam Deck

This repository packages [wii-u-gc-adapter](https://github.com/ToadKing/wii-u-gc-adapter) for the Steam Deck in a way that is simple for anyone to install and robust to OS updates.

## Installation

On your Steam Deck, enter Desktop Mode and open Konsole. Then run the following command to install and enable the driver:

```sh
curl -L "https://github.com/MageJohn/steam-deck-gc-adapter/releases/latest/download/bootstrap.sh" | bash
```

When it finishes you can plug in an adapter and test it out in Steam or a game!

## Technical information

The install script `bootstrap.sh` downloads the release tarball and executes the `scripts/install.sh` from it, which does the real work. It performs the following steps

- Install a udev rule that allows non-root users to read from the USB device
- Install a systemd unit which ensure the driver runs whenever the Deck starts
- Installs the driver binary itself
- Configures Steam with the correct bindings, so that buttons are correctly mapped. This is done with a seperate Python script.
- Finally, enables and starts the systemd unit

## Troubleshooting

To check if the driver is running, run `systemctl status --user wii-u-gc-adapter`. This will show green `active (running)` if the driver is up. It should also show the most recent log output, including connect/disconnect events for adapters and ports.

If the bindings are messed up, then you might have to reconfigure them through Steam. In Steam, go to Settings -> Controllers, make sure you've selected a plugged in GameCube controller, then hit the Begin Test button. There, use the Paste Bindings button to paste the following snippet:

```
0300788f7e0500003703000000000000,Wii U GameCube Adapter,platform:Linux,a:b0,x:b3,b:b1,y:b2,dpleft:b10,dpright:b11,dpup:b8,dpdown:b9,leftx:a0,lefty:a1,rightx:a3,righty:a4,lefttrigger:a2,rightshoulder:b6,righttrigger:a5,start:b7,steam:2,hint:!SDL_GAMECONTROLLER_USE_GAMECUBE_LABELS:=1,
```

If you can't copy and paste that (this might be tricky in Gaming Mode), then hit Setup Controls and follow the process. However, you'll have to do the same for each port due to how the bindings are matched to controllers. The line above doesn't have that issue because the CRC hash of the name has been removed.

