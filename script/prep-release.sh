#!/bin/bash
# prep release for upload to production container

set -e

# make ipxe directory to store ipxe disks
mkdir -p build/ipxe

# pull down upstream iPXE
git clone --depth 1 https://github.com/ipxe/ipxe.git ipxe_build

# copy iPXE config overrides into source tree
cp ipxe/local/* ipxe_build/src/config/local/

# copy certs into source tree
cp script/*.crt ipxe_build/src/

# build iPXE disks
cd ipxe_build/src

# get current iPXE hash
IPXE_HASH=`git log -n 1 --pretty=format:"%H"`

# generate pxe.to iPXE disks
make bin/ipxe.dsk bin/ipxe.iso bin/ipxe.lkrn bin/ipxe.usb bin/ipxe.kpxe bin/undionly.kpxe \
EMBED=../../ipxe/disks/pxe.to TRUST=ca-ipxe-org.crt,ca-pxe.to.crt
mv bin/ipxe.dsk ../../build/ipxe/pxe.to.dsk
mv bin/ipxe.iso ../../build/ipxe/pxe.to.iso
mv bin/ipxe.lkrn ../../build/ipxe/pxe.to.lkrn
mv bin/ipxe.usb ../../build/ipxe/pxe.to.usb
mv bin/ipxe.kpxe ../../build/ipxe/pxe.to.kpxe
mv bin/undionly.kpxe ../../build/ipxe/pxe.to-undionly.kpxe

# generate pxe.to iPXE disk for Google Compute Engine
make bin/ipxe.usb CONFIG=cloud EMBED=../../ipxe/disks/pxe.to-gce \
TRUST=ca-ipxe-org.crt,ca-pxe.to.crt
cp -f bin/ipxe.usb disk.raw
tar Sczvf pxe.to-gce.tar.gz disk.raw
mv pxe.to-gce.tar.gz ../../build/ipxe/pxe.to-gce.tar.gz

# generate pxe.to-packet iPXE disk
make bin/undionly.kpxe \
EMBED=../../ipxe/disks/pxe.to-packet TRUST=ca-ipxe-org.crt,ca-pxe.to.crt
mv bin/undionly.kpxe ../../build/ipxe/pxe.to-packet.kpxe

# generate EFI iPXE disks
cp config/local/general.h.efi config/local/general.h
make clean
make bin-x86_64-efi/ipxe.efi \
EMBED=../../ipxe/disks/pxe.to TRUST=ca-ipxe-org.crt,ca-pxe.to.crt
mkdir -p efi_tmp/EFI/BOOT/
cp bin-x86_64-efi/ipxe.efi efi_tmp/EFI/BOOT/bootx64.efi
genisoimage -o ipxe.eiso efi_tmp
mv bin-x86_64-efi/ipxe.efi ../../build/ipxe/pxe.to.efi
mv ipxe.eiso ../../build/ipxe/pxe.to-efi.iso

# generate EFI arm64 iPXE disk
make clean
make CROSS_COMPILE=aarch64-linux-gnu- ARCH=arm64 \
EMBED=../../ipxe/disks/pxe.to TRUST=ca-ipxe-org.crt,ca-pxe.to.crt \
bin-arm64-efi/snp.efi
mv bin-arm64-efi/snp.efi ../../build/ipxe/pxe.to-arm64.efi

# generate pxe.to-packet-arm64 iPXE disk
make clean
make CROSS_COMPILE=aarch64-linux-gnu- ARCH=arm64 \
EMBED=../../ipxe/disks/pxe.to-packet TRUST=ca-ipxe-org.crt,ca-pxe.to.crt \
bin-arm64-efi/snp.efi
mv bin-arm64-efi/snp.efi ../../build/ipxe/pxe.to-packet-arm64.efi

# generate arm64 experimental
cp config/local/nap.h.efi config/local/nap.h
cp config/local/usb.h.efi config/local/usb.h
make clean
make CROSS_COMPILE=aarch64-linux-gnu- ARCH=arm64 \
EMBED=../../ipxe/disks/pxe.to TRUST=ca-ipxe-org.crt,ca-pxe.to.crt \
bin-arm64-efi/snp.efi
mv bin-arm64-efi/snp.efi ../../build/ipxe/pxe.to-arm64-experimental.efi

# return to root
cd ../..

# generate header for sha256-checksums file
cd build/
CURRENT_TIME=`date`
cat > pxe.to-sha256-checksums.txt <<EOF
# pxe.to bootloaders generated at $CURRENT_TIME
# iPXE Commit: https://github.com/ipxe/ipxe/commit/$IPXE_HASH
# Travis-CI Job: https://travis-ci.org/pxe2/pxe.to/builds/$TRAVIS_BUILD_ID

EOF

# generate sha256sums for iPXE disks
cd ipxe/
for ipxe_disk in `ls .`
do
  sha256sum $ipxe_disk >> ../pxe.to-sha256-checksums.txt
done
cat ../pxe.to-sha256-checksums.txt
mv ../pxe.to-sha256-checksums.txt .
cd ../..

# generate signatures for pxe.to source files
mkdir sigs
for src_file in `ls src`
do
  openssl cms -sign -binary -noattr -in src/$src_file \
  -signer script/codesign.crt -inkey script/codesign.key -certfile script/ca-pxe.to.crt -outform DER \
  -out sigs/$src_file.sig
  echo Generated signature for $src_file...
done
mv sigs src/

# delete index.html so that we don't overwrite existing content type
rm src/index.html

# copy iPXE src code into build directory
cp -R src/* build/
