QEMU_VERSION="2.9.0"
QEMU_URL="http://download.qemu-project.org/qemu-2.9.0.tar.xz"
QEMU_MD5="86c95eb3b24ffea3a84a4e3a856b4e26"

echo "================================================="
echo "                kAFL setup script                "
echo "================================================="

echo
echo "[*] Performing basic sanity checks..."


for i in dpkg; do
  T=`which "$i" 2>/dev/null`
  if [ "$T" = "" ]; then
    echo "[-] Error: '$i' not found, please install first."
    exit 1
  fi
done

echo "[*] Installing build dependencies for QEMU $QEMU_VERSION ..."
sudo -Eu root apt-get build-dep qemu-system-x86 libgtk2.0-dev flex -y


echo "[*] Installing python essentials ..."
sudo -Eu root pip2.7 install mmh3 lz4 psutil > /dev/null 2> /dev/null

echo
echo "[*] Downloading QEMU $QEMU_VERSION ..."
wget -O qemu.tar.gz $QEMU_URL 2

echo "[*] Checking signature of QEMU $QEMU_VERSION ..."
CHKSUM=`md5sum qemu.tar.gz| cut -d' ' -f1`

if [ "$CHKSUM" != "$QEMU_MD5" ]; then
  echo "[-] Error: signature mismatch..."
  exit 1
fi

