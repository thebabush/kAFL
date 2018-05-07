LINUX_VERSION="4.6.2"
LINUX_URL="https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-$LINUX_VERSION.tar.xz"
LINUX_MD5="70c4571bfb7ce7ccb14ff43b50165d43"

echo "[*] Unpacking Kernel $LINUX_VERSION ..."
tar xf kernel.tar.gz

echo "[*] Patching Kernel $LINUX_VERSION ..."
patch linux-$LINUX_VERSION/arch/x86/kvm/x86.c < KVM-PT/arch/x86/kvm/x86.c.patch > /dev/null
patch linux-$LINUX_VERSION/include/uapi/linux/kvm.h <  KVM-PT/include/uapi/linux/kvm.h.patch > /dev/null

mkdir linux-$LINUX_VERSION/usermode_test/ 2> /dev/null
cp KVM-PT/usermode_test/support_test.c linux-$LINUX_VERSION/usermode_test/
cp KVM-PT/usermode_test/test.c linux-$LINUX_VERSION/usermode_test/

echo "[*] Compiling Kernel $LINUX_VERSION ..."
cd linux-$LINUX_VERSION/
yes "" | make oldconfig  > oldconfig.log

if [ ! "` grep \"CONFIG_KVM_VMX_PT=y\" .config | wc -l`" = "1" ]; then
  echo "CONFIG_KVM_VMX_PT=y" >> .config
fi
echo "-------------------------------------------------"
make -j 8
echo "-------------------------------------------------"

echo "KERNEL==\"kvm\", GROUP=\"kvm\"" | sudo -Eu root tee /etc/udev/rules.d/40-permissions.rules > /dev/null

sudo -Eu root groupadd kvm
sudo -Eu root usermod -a -G kvm $USER
sudo -Eu root service udev restart

sudo -Eu root make modules_install
sudo -Eu root make install
cd ../

echo 
echo "[*] Done! Please reboot your system now!"


