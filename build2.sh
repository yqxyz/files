# MMI-S1RXC32.50-37-2 for moto edge S30

# Kernel Modules:
# ---------------
# Download prebuilts folder from Android distribution. Move it to $my_top_dir

# For example:
my_top_dir=$PWD

mkdir -vp  $my_top_dir/prebuilts/clang/host/linux-x86/

cd $my_top_dir/prebuilts/clang/host/linux-x86/

wget -q https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/+archive/e532342f30eadb954c96d19ca6a0edf89a5c65bc/clang-r383902b1.tar.gz
tar -xf clang*
rm clang*.tar.gz
mkdir -vp  $my_top_dir/prebuilts/gcc/linux-x86
cd $my_top_dir/prebuilts/gcc/linux-x86

git clone https://github.com/LineageOS/android_prebuilts_gcc_linux-x86_aarch64_aarch64-linux-android-4.9.git --depth=1 aarch64

cd $my_top_dir/prebuilts/gcc/linux-x86/
git clone https://github.com/LineageOS/android_prebuilts_gcc_linux-x86_arm_arm-linux-androideabi-4.9.git  --depth=1 arm


mkdir -p $my_top_dir/out/target/product/generic/obj/kernel/msm-5.4 

kernel_out_dir=$my_top_dir/out/target/product/generic/obj/kernel/msm-5.4 

clang=$my_top_dir/prebuilts/clang/host/linux-x86/bin/clang

ld_lld=$my_top_dir/prebuilts/clang/host/linux-x86/bin/ld.lld

llvm_ar=$my_top_dir/prebuilts/clang/host/linux-x86/bin/llvm-ar

llvm_nm=$my_top_dir/prebuilts/clang/host/linux-x86/bin/llvm-nm
mkdir -p $my_top_dir/prebuilts/build-tools
cd $my_top_dir/prebuilts/build-tools
wget https://android.googlesource.com/platform/prebuilts/build-tools/+archive/refs/heads/llvm-r383902b.tar.gz

tar -zxf llvm-r383902b.tar.gz
rm llvm-r383902b.tar.gz


make=$my_top_dir/prebuilts/build-tools/linux-x86/bin/make

aarch64_linux_android_=$my_top_dir/prebuilts/gcc/linux-x86/aarch64/bin/aarch64-linux-android-
mkdir -p $my_top_dir/prebuilts/gcc/linux-x86/host/x86_64-linux-glibc2.17-4.8
cd $my_top_dir/prebuilts/gcc/linux-x86/host/x86_64-linux-glibc2.17-4.8
wget https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/host/x86_64-linux-glibc2.17-4.8/+archive/refs/heads/llvm-r383902b.tar.gz
tar -zxf llvm-r383902b.tar.gz
rm llvm-r383902b.tar.gz
x86_64_linux_ar=$my_top_dir/prebuilts/gcc/linux-x86/host/x86_64-linux-glibc2.17-4.8/bin/x86_64-linux-ar

x86_64_linux_ld=$my_top_dir/prebuilts/gcc/linux-x86/host/x86_64-linux-glibc2.17-4.8/bin/x86_64-linux-ld

arm_eabi_=$my_top_dir/prebuilts/gcc/linux-x86/arm/bin/arm-linux-androideabi-
cd $my_top_dir/prebuilts/
wget https://android.googlesource.com/platform/prebuilts/misc/+/ee3b4c119a8371677ba59cfb7320c1c0c69b4235/linux-x86/libufdt/ufdt_apply_overlay
wget https://android.googlesource.com/platform/prebuilts/misc/+/ee3b4c119a8371677ba59cfb7320c1c0c69b4235/linux-x86/dtc/dtc
export TARGET_BUILD_VARIANT=user TARGET_PRODUCT=xpeng_retcn
local_dtc=$my_top_dir/prebuilts/dtc
local_ufdt=$my_top_dir/prebuilts/ufdt_apply_overlay
cd $my_top_dir/kernel/msm-5.4/scripts/gki

source $my_top_dir/kernel/msm-5.4/scripts/gki/envsetup.sh lahaina

cd $my_top_dir

MAKE_PATH= ARCH=arm64 CROSS_COMPILE=$aarch64_linux_android_ REAL_CC=$clang CLANG_TRIPLE=aarch64-linux-gnu- AR=$llvm_ar LLVM_NM=$llvm_nm LD=$ld_lld NM=$llvm_nm KERN_OUT=$kernel_out_dir DTC_EXT=$local_dtc DTC_OVERLAY_TEST_EXT=$local_ufdt CONFIG_BUILD_ARM64_DT_OVERLAY=y HOSTCC=$clang HOSTAR=$x86_64_linux_ar HOSTLD=$x86_64_linux_ld TARGET_BUILD_VARIANT=user kernel/msm-5.4/scripts/gki/generate_defconfig.sh vendor/lahaina-qgki_defconfig


$make -j48 -C kernel/msm-5.4  O=$kernel_out_dir REAL_CC=$clang CLANG_TRIPLE=aarch64-linux-gnu- AR=$llvm_ar LLVM_NM=$llvm_nm LD=$ld_lld NM=$llvm_nm DTC_EXT=$local_dtc DTC_OVERLAY_TEST_EXT=$local_ufdt CONFIG_BUILD_ARM64_DT_OVERLAY=y HOSTCC=$clang HOSTAR=$x86_64_linux_ar HOSTLD=$x86_64_linux_ld HOSTCFLAGS="-I$my_top_dir/kernel/msm-5.4/include/uapi -I/usr/include -I/usr/include/x86_64-linux-gnu -I$my_top_dir/kernel/msm-5.4/include -L/usr/lib -L/usr/lib/x86_64-linux-gnu -fuse-ld=lld" HOSTLDFLAGS="-L/usr/lib -L/usr/lib/x86_64-linux-gnu -fuse-ld=lld" ARCH=arm64 CROSS_COMPILE=$aarch64_linux_android_ vendor/lahaina-qgki_defconfig

 $make -j48 -C kernel/msm-5.4  HOSTCFLAGS="-I$my_top_dir/kernel/msm-5.4/include/uapi -I/usr/include -I/usr/include/x86_64-linux-gnu -I$my_top_dir/kernel/msm-5.4/include -L/usr/lib -L/usr/lib/x86_64-linux-gnu -fuse-ld=lld" HOSTLDFLAGS="-L/usr/lib -L/usr/lib/x86_64-linux-gnu -fuse-ld=lld" ARCH=arm64 CROSS_COMPILE=$aarch64_linux_android_ O=$kernel_out_dir REAL_CC=$clang CLANG_TRIPLE=aarch64-linux-gnu- AR=$llvm_ar LLVM_NM=$llvm_nm LD=$ld_lld NM=$llvm_nm DTC_EXT=$local_dtc DTC_OVERLAY_TEST_EXT=$local_ufdt CONFIG_BUILD_ARM64_DT_OVERLAY=y HOSTCC=$clang HOSTAR=$x86_64_linux_ar HOSTLD=$x86_64_linux_ld headers_install

 $make -j48 -C kernel/msm-5.4  ARCH=arm64 CROSS_COMPILE=$aarch64_linux_android_ HOSTCFLAGS="-I$my_top_dir/kernel/msm-5.4/include/uapi -I/usr/include -I/usr/include/x86_64-linux-gnu -I$my_top_dir/kernel/msm-5.4/include -L/usr/lib -L/usr/lib/x86_64-linux-gnu -fuse-ld=lld" HOSTLDFLAGS="-L/usr/lib -L/usr/lib/x86_64-linux-gnu -fuse-ld=lld" O=$kernel_out_dir  REAL_CC=$clang CLANG_TRIPLE=aarch64-linux-gnu- AR=$llvm_ar LLVM_NM=$llvm_nm LD=$ld_lld NM=$llvm_nm DTC_EXT=$local_dtc DTC_OVERLAY_TEST_EXT=$local_ufdt CONFIG_BUILD_ARM64_DT_OVERLAY=y HOSTCC=$clang HOSTAR=$x86_64_linux_ar HOSTLD=$x86_64_linux_ld
 
$make -j48 -C kernel/msm-5.4 O=$kernel_out_dir ARCH=arm64 CROSS_COMPILE=$aarch64_linux_android_ HOSTCFLAGS="-I$my_top_dir/kernel/msm-5.4/include/uapi -I/usr/include -I/usr/include/x86_64-linux-gnu -I$my_top_dir/kernel/msm-5.4/include -L/usr/lib -L/usr/lib/x86_64-linux-gnu -fuse-ld=lld" HOSTLDFLAGS="-L/usr/lib -L/usr/lib/x86_64-linux-gnu -fuse-ld=lld" INSTALL_MOD_STRIP=1 INSTALL_MOD_PATH=$kernel_out_dir/staging REAL_CC=$clang CLANG_TRIPLE=aarch64-linux-gnu- AR=$llvm_ar LLVM_NM=$llvm_nm LD=$ld_lld NM=$llvm_nm DTC_EXT=$local_dtc DTC_OVERLAY_TEST_EXT=$local_ufdt CONFIG_BUILD_ARM64_DT_OVERLAY=y HOSTCC=$clang HOSTAR=$x86_64_linux_ar HOSTLD=$x86_64_linux_ld modules_install
# function push() {
# 	curl -F document=@$1 "https://api.telegram.org/bot$token/sendDocument" \
# 	-F chat_id="$chat_id" \
# 	-F "disable_web_page_preview=true" \
# 	-F "parse_mode=html" \
# 	-F caption="$2"
# 	}
#  	# Copy Files To AnyKernel3 Zip
# cd $my_top_dir
# git clone --depth=1 https://github.com/ImSpiDy/AnyKernel3
# cp -r $my_top_dir/out/target/product/generic/obj/kernel/msm-5.4/arch/arm64/boot AnyKernel3
cp $my_top_dir/out/target/product/generic/obj/kernel/msm-5.4/.config  $my_top_dir/out/target/product/generic/obj/kernel/msm-5.4/arch/arm64/boot/config

# # Zipping and Push Kernel
# cd AnyKernel3 || exit 1
# FINAL_ZIP="msm-5.4-"+$(TZ=Asia/Kolkata date +"%Y%m%d-%T")
# zip -r9 $FINAL_ZIP *
# MD5CHECK=$(md5sum "$FINAL_ZIP" | cut -d' ' -f1)
# push "$FINAL_ZIP" "MD5 :  <b>MD5 Checksum : </b><code>$MD5CHECK</code>"


function post_msg() {
	curl -s -X POST "https://api.telegram.org/bot$token/sendMessage" \
	-d chat_id="$chat_id" \
	-d "disable_web_page_preview=true" \
	-d "parse_mode=html" \
	-d text="$1"
	}
post_msg "finish"