<h1 align="center">
  <p>
  <img src="https://raw.githubusercontent.com/MageJohn/steam-deck-gc-adapter/refs/heads/master/images/steam-deck-gc-adapter.svg" alt="steam-deck-gc-adapter logo" width="300">
  </p>
  Steam Deck GameCube Adapter
</h1>

<p align="center">
  <a href="https://github.com/MageJohn/steam-deck-gc-adapter/actions/workflows/build.yaml"><img src="https://github.com/MageJohn/steam-deck-gc-adapter/actions/workflows/build.yaml/badge.svg" /></a>
</p>

This repository packages [wii-u-gc-adapter](https://github.com/ToadKing/wii-u-gc-adapter) for the Steam Deck in a way that is simple for anyone to install and robust to OS updates.

## Installation

First, these instructions will be easier if you are able to open this page in a browser. I recommend Firefox, available from the Discover store in Desktop mode. The installation will also be easier if you have an external keyboard and mouse, but it should be possible to complete it without them.

On your Steam Deck, enter Desktop Mode and open Konsole, the terminal program. Then run the following command to install and enable the driver:

```sh
curl -L "https://github.com/MageJohn/steam-deck-gc-adapter/releases/latest/download/bootstrap.sh" | bash
```

When it finishes, it will print instructions on setting up the controller with Steam so the buttons are correctly mapped. Once this is complete, you can go back into Gaming mode and test it out!

### Offline installation

The tarball available from the Releases section (or the one downloaded by the `bootstrap.sh`) operates entirely offline. This might be useful if you need to set up multiple Steam Decks quickly.

## Technical information

The install script `bootstrap.sh` downloads the release tarball and executes `scripts/install.sh` from it, which does the real work. It performs the following steps:

- Installs a systemd timer and service which ensure the driver runs whenever the Deck starts
- Installs the driver binary itself, which has been built to work on Steam OS
- Finally, enables the timer, and starts the service

## Troubleshooting

To check if the driver is running, run `systemctl status --user wii-u-gc-adapter.service`. This will show green `active (running)` if the driver is up. It should also show the most recent log output, including connect/disconnect events for adapters and ports. You can restart the driver with `systemctl restart --user wii-u-gc-adapter.service`, and there are similar `start` and `stop` commands that might be useful.

If the button mappings get screwed up, you can configure them in the same way the installer instructs you. In Desktop mode Steam, go to Settings -> Controllers, make sure you've selected a plugged in GameCube controller, then hit the Begin Test button. There, hit Setup Controls and use the Paste Bindings button to paste the following snippet:

```
0300788f7e0500003703000000000000,Wii U GameCube Adapter,platform:Linux,a:b0,x:b3,b:b1,y:b2,dpleft:b10,dpright:b11,dpup:b8,dpdown:b9,leftx:a0,lefty:a1,rightx:a3,righty:a4,lefttrigger:a2,rightshoulder:b6,righttrigger:a5,start:b7,steam:2,hint:!SDL_GAMECONTROLLER_USE_GAMECUBE_LABELS:=1,
```

If you want to do it from Gaming Mode, then you can use the same testing facility from there, but you will have to manually go through the setup process.
