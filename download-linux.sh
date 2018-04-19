LINUX_VERSION="4.6.2"
LINUX_URL="https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-$LINUX_VERSION.tar.xz"
LINUX_MD5="70c4571bfb7ce7ccb14ff43b50165d43"



echo
echo "[*] Downloading Kernel $LINUX_VERSION ..."
wget -O kernel.tar.gz $LINUX_URL 2> /dev/null

echo "[*] Checking signature of Kernel $LINUX_VERSION ..."
CHKSUM=`md5sum kernel.tar.gz| cut -d' ' -f1`

if [ "$CHKSUM" != "$LINUX_MD5" ]; then
  echo "[-] Error: signature mismatch..."
  echo "$CHKSUM"
  echo "$LINUX_MD5"
  exit 1
fi