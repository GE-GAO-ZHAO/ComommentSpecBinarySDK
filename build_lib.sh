#!/bin/sh

#  Script.sh
#  ABC
#
#  Created by 葛高召 on 2022/1/6.
#  Copyright © 2022 葛高召. All rights reserved.

echo ///                        ///
echo /// 🚀开始延迟编译二进制库🚀  ///
echo ///                       ///

printCurDirInfo() {
    echo ====== 😄目录信息😄 ======
    path=`cd $(dirname $0);pwd -P`
    echo the current path is:$path
    for i in `ls`
    do
            echo $i
    done
    filename=`basename $0`
    echo file name is:$filename
    echo ====== 😄目录信息😄 ======
}

#脚本所在目录
printCurDirInfo

#进入工程根目录
cd Example
printCurDirInfo

#workspace名、scheme名字
PROJECT_NAME='ABC'
BINARY_NAME="${PROJECT_NAME}"

#framework路径
INSTALL_DIR=../PodProducts
rm -dr "${INSTALL_DIR}"
mkdir $INSTALL_DIR

#编译场地
WRK_DIR=build
BUILD_PATH=${WRK_DIR}
RE_OS="Release-iphoneos"
RE_SIMULATOR="Release-iphonesimulator"
DEVICE_DIR=${BUILD_PATH}/${RE_OS}/${BINARY_NAME}.framework
SIMULATOR_DIR=${BUILD_PATH}/${RE_SIMULATOR}/${BINARY_NAME}.framework

#分别编译模拟器和真机的Framework
xcodebuild -configuration "Release" -workspace "${PROJECT_NAME}.xcworkspace" -scheme "${BINARY_NAME}" ONLY_ACTIVE_ARCH=NO -sdk iphoneos CONFIGURATION_BUILD_DIR="${WRK_DIR}/${RE_OS}" clean build
xcodebuild -configuration "Release" -workspace "${PROJECT_NAME}.xcworkspace" -scheme "${BINARY_NAME}" ONLY_ACTIVE_ARCH=NO ARCHS='i386 x86_64' VALID_ARCHS='i386 x86_64' -sdk iphonesimulator CONFIGURATION_BUILD_DIR="${WRK_DIR}/${RE_SIMULATOR}" clean build

#合成fat库
printCurDirInfo
INSTALL_LIB_DIR=${INSTALL_DIR}/${BINARY_NAME}.framework
if [ -d "${INSTALL_LIB_DIR}" ]
then
rm -rf "${INSTALL_LIB_DIR}"
fi
mkdir -p "${INSTALL_LIB_DIR}"
cp -a "${DEVICE_DIR}/" "${INSTALL_LIB_DIR}/"
lipo -create "${DEVICE_DIR}/${BINARY_NAME}" "${SIMULATOR_DIR}/${BINARY_NAME}" -output "${INSTALL_LIB_DIR}/${BINARY_NAME}"

#删除编译产物
rm -dr $WRK_DIR

echo ///                        ///
echo /// 🚀完成延迟编译二进制库🚀  ///
echo ///                       ///
