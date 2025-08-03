#!/bin/sh

# LOCAL_PATH="/home/sean/.local"
BIN_PATH="$HOME/bin"

kill -9 $(pidof dwm)
kill -9 $(pidof dwmblocks)

$BIN_PATH/dwm 2> $HOME/.config/dwm/dwm.log &
$BIN_PATH/dwmblocks 2> $HOME/.config/dwm/dwmblocks_async.log


