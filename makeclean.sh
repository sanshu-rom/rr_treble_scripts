#!/bin/bash

rom_fp="$(date +%y%m%d)"

export LC_ALL=C

export RR_BUILDTYPE=Official
export days_to_log=7
source build/envsetup.sh

#lunch
lunch treble_arm64_avN-userdebug

#cache
#export USE_CCACHE=1
#ccache -M 100G
#export CCACHE_COMPRESS=1

#installclean
make clean
make clobber

echo -e "Stopping jack server"
./prebuilts/sdk/tools/jack-admin stop-server

