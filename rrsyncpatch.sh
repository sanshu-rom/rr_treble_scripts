#!/bin/bash

#definations
localManifestBranch=android-8.1
source=~/android/rrtreble/
rom_fp="$(date +%y%m%d)"
rom=rr
jobs=16

#clone local_manifests from phh repo
if [ -d .repo/local_manifests ] ;then
	( cd .repo/local_manifests; git fetch; git reset --hard; git checkout origin/$localManifestBranch)
else
	git clone https://github.com/phhusson/treble_manifest .repo/local_manifests -b $localManifestBranch
fi

#dont replace with aosp sources
rm -f .repo/local_manifests/replace.xml

repo sync -c -j$jobs --force-sync
rm -f device/*/sepolicy/common/private/genfs_contexts
(cd device/phh/treble; git clean -fdx; bash generate.sh $rom)

bash apply-patchesrr.sh patches
