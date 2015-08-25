#!/bin/sh

set -e

if [ ! -f "build/env.sh" ]; then
    echo "$0 must be run from the root of the repository."
    exit 2
fi

# Create fake Go workspace if it doesn't exist yet.
fake_workspace="$PWD/build/_workspace"
ethdir="$fake_workspace/src/github.com/ethereum"
if [ ! -L "$ethdir/go-ethereum" ]; then
    mkdir -p "$ethdir"
    ln -s ../../../../../. $ethdir/go-ethereum
fi

# Set up the environment to use the workspace.
# Also add Godeps workspace so we build using canned dependencies.
GOPATH="Godeps/_workspace:$fake_workspace"
GOBIN="$PWD/build/bin"
export GOPATH GOBIN

# Run the command inside the workspace.
cd "$ethdir/go-ethereum"

# Launch the arguments with the configured environment.
exec "$@"
