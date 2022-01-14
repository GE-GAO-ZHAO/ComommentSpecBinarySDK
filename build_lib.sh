#!/bin/sh

#  Script.sh
#  ABC
#
#  Created by 葛高召 on 2022/1/6.
#  Copyright © 2022 葛高召. All rights reserved.

#workspace名、scheme名字
PROJECT_NAME='ABC'
BINARY_NAME="${PROJECT_NAME}Binary"

#删除之前的framework产物
INSTALL_DIR=$PWD/../Pod/Products
rm -dr "${INSTALL_DIR}"
mkdir $INSTALL_DIR

#编译场地
cd Example
WRK_DIR=build
BUILD_PATH=${WRK_DIR}
DEVICE_DIR=${BUILD_PATH}/Release-iphoneos/${BINARY_NAME}.framework
SIMULATOR_DIR=${BUILD_PATH}/Release-iphonesimulator/${BINARY_NAME}.framework
RE_OS="Release-iphoneos"
RE_SIMULATOR="Release-iphonesimulator"

#分别编译模拟器和真机的Framework
xcodebuild -configuration "Release" -workspace "${PROJECT_NAME}.xcworkspace" -scheme "${BINARY_NAME}" ONLY_ACTIVE_ARCH=NO -sdk iphoneos CONFIGURATION_BUILD_DIR="${WRK_DIR}/${RE_OS}" clean build
xcodebuild -configuration "Release" -workspace "${PROJECT_NAME}.xcworkspace" -scheme "${BINARY_NAME}" ONLY_ACTIVE_ARCH=NO ARCHS='i386 x86_64' VALID_ARCHS='i386 x86_64' -sdk iphonesimulator CONFIGURATION_BUILD_DIR="${WRK_DIR}/${RE_SIMULATOR}" clean build

#合成fat库
INSTALL_LIB_DIR=${INSTALL_DIR}/lib/${BINARY_NAME}.framework
if [ -d "${INSTALL_LIB_DIR}" ]
then
rm -rf "${INSTALL_LIB_DIR}"
fi
mkdir -p "${INSTALL_LIB_DIR}"
cp -R "${DEVICE_DIR}/" "${INSTALL_LIB_DIR}/"
lipo -create "${DEVICE_DIR}/${BINARY_NAME}" "${SIMULATOR_DIR}/${BINARY_NAME}" -output "${INSTALL_LIB_DIR}/${BINARY_NAME}"

#删除编译产物
rm -dr $WRK_DIR
