#!/bin/sh
echo -ne '\033c\033]0;Clumsy Castle Combat\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/Network.x86_64" "$@"
