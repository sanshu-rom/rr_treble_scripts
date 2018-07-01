#!/bin/bash

rom_fp="$(date +%y%m%d)"

export LC_ALL=C

export RR_BUILDTYPE=Official
export days_to_log=7
source build/envsetup.sh

#doubledefination
if [ -f vendor/rr/prebuilt/common/Android.mk ];then
    sed -i \
        -e 's/LOCAL_MODULE := Wallpapers/LOCAL_MODULE := WallpapersRR/g' \
        vendor/rr/prebuilt/common/Android.mk
fi

#lunch
lunch treble_arm64_agS-userdebug

#make bigger
sed -i -e 's/BOARD_SYSTEMIMAGE_PARTITION_SIZE := 1610612736/BOARD_SYSTEMIMAGE_PARTITION_SIZE := 2147483648/g' device/phh/treble/phhgsi_arm64_a/BoardConfig.mk

#cache
export USE_CCACHE=1
ccache -M 100G
export CCACHE_COMPRESS=1

#installclean
make WITHOUT_CHECK_API=true I_WANT_A_QUAIL_STAR=true BUILD_NUMBER=$rom_fp installclean

#build
make WITHOUT_CHECK_API=true I_WANT_A_QUAIL_STAR=true BUILD_NUMBER=$rom_fp -j16 systemimage

#testsepolicy
make BUILD_NUMBER=$rom_fp vndk-test-sepolicy

mv $OUT/system.img release/$rom_fp/system-$rom_fp-arm64-aonly-gapps-su.img

echo -e "Stopping jack server"
./prebuilts/sdk/tools/jack-admin stop-server
