import argparse
import vdf
import fileinput
from pathlib import Path

parser = argparse.ArgumentParser(
    prog="sdl_bind_append",
    description="Add SDL Gamepad definitions to a Steam config.vdf",
)

parser.add_argument("vdf")
parser.add_argument("def_file")


def main(file, def_file):
    data = None
    Path(file).touch(exist_ok=True)
    with open(file, "r") as f:
        data = vdf.load(f)
    store = data.setdefault("InstallConfigStore", {})
    sdl_binds = store.setdefault("SDL_GamepadBind", "").splitlines()

    defs = None
    with open(def_file, "r") as f:
        defs = [l.strip() for l in f]

    sdl_binds.extend(defs)
    store["SDL_GamepadBind"] = "\n".join(sdl_binds)
    with open(file, "w") as f:
        vdf.dump(data, f, pretty=True, escaped=False)


if __name__ == "__main__":
    args = parser.parse_args()
    main(args.vdf, args.def_file)
