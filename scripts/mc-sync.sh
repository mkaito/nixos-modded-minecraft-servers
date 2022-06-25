#!/usr/bin/env bash
# shellcheck disable=SC2029

set -euo pipefail
ROOT="$(dirname "$(realpath "$0")")"

## Instructions
#
#  Installation: Symlink onto $PATH. Modify rsyncignore in this folder if necessary.
#
#  Usage: mc-sync.sh <instance> <server> <push|pull> [--full]
#   mc-sync.sh mc-e2es stargazer.mkaito.net push --full

if [[ ! -f start.sh ]]; then
  echo 'Could not find start.sh in current folder. Aborging.'
  exit 1
fi

if [[ -n ${1:-} ]]; then
    TUSER="$1"
    TPATH="::$1/"
else
    echo "Please provide an instance name, such as mc-e2es."
    exit 1
fi

if [[ -n ${2:-} ]]; then
    THOST="$2"
else
    echo "Please provide a target hostname or SSH alias."
    exit 1
fi


RSYNCOPTS=(-avzzpL -e ssh --delete)
if [[ -z ${4:-} ]]; then
    RSYNCOPTS+=(--exclude-from="$ROOT"/rsyncignore)
fi

ssh "$THOST" sudo systemctl stop "$TUSER"

taction="${3:-push}"
if [[ $taction == push ]]; then
    rsync "${RSYNCOPTS[@]}" ./ "${TUSER}@${THOST}${TPATH}"
elif [[ $taction == pull ]]; then
    rsync "${RSYNCOPTS[@]}" "${TUSER}@${THOST}${TPATH}" ./
fi

ssh "$THOST" sudo systemctl start "$TUSER"
