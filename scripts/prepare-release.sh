#!/bin/bash

set -o errexit

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
ROOT=$(realpath "$SCRIPT_DIR/..")

# shellcheck source=./lib/colours.sh
source "$SCRIPT_DIR/lib/colours.sh"

_usage() {
  echo "$0 [-p | --patch] [-m | --minor] [-M | --major] [-d | --dry-run]"
}

BUMP="patch"
DRY=0

while [[ $# -gt 0 ]]; do
  case $1 in
    -p|--patch)
      BUMP="patch"
    ;;
    -m|--minor)
      BUMP="minor"
    ;;
    -M|--major)
      BUMP="major"
    ;;
    -d|--dry-run)
      DRY=1
    ;;
    *)
      _usage
      exit 1
    ;;
  esac

  shift
done

cur_version=$(git describe --abbrev=0)
cur_ver_split=$(sed -E 's/v([0-9]+).([0-9]+).([0-9]+)/\1 \2 \3/' \
  <<<"$cur_version")
read -r major minor patch <<<"$cur_ver_split"

declare $BUMP=$((${!BUMP} + 1))

if [[ "$BUMP" == "minor" ]]; then
  patch="0"
fi
if [[ "$BUMP" == "major" ]]; then
  patch="0"
  minor="0"
fi

new_version="v${major}.${minor}.${patch}"

if [[ "$DRY" == "1" ]]; then
  echo "New version: $new_version"
  exit 0
fi

if ! git diff --quiet; then
  echo -e "Stashing changes"
  git stash push --quiet

  _pop_stash() {
    echo "Popping saved changes from stash"
    git stash pop --quiet
  }

  trap _pop_stash EXIT
fi

sed -Ei "/VERSION=/s/v[0-9]+.[0-9]+.[0-9]+/${new_version}/" \
  "$ROOT/scripts/bootstrap.sh"
git add "$ROOT/scripts/bootstrap.sh"
git commit -m "Bump version in bootstrap.sh to $new_version"
git tag -a "$new_version" -m ''

echo -e "${Blu}Inspect the changes and then push them with \`git push --follow-tags\`" \
  "to create a Github Release${RCol}"