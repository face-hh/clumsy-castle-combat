#!/bin/sh
echo -ne '\033c\033]0;Network\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/Network.arm64.x86_64" "$@"
