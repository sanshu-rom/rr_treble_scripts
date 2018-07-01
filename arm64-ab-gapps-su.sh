#!/bin/bash

export LC_ALL=C

export RR_BUILDTYPE=Official
export days_to_log=7
source build/envsetup.sh

#lunch
lunch treble_arm64_bgS-userdebug

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

mv $OUT/system.img release/$rom_fp/system-$rom_fp-arm64-ab-gapps-su.img
