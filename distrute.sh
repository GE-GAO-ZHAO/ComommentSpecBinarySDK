#!/bin/sh

#  Script.sh
#  ABC
#
#  Created by 葛高召 on 2022/1/6.
#  Copyright © 2022 葛高召. All rights reserved.

echo "\n ****** 设置最新的静态库代码 spec begin ****** \n"

#复制pod库class下的源码到静态库

#更新需要公开的头文件写入根头文件

echo "\n ****** 设置最新的静态库代码 spec end ****** \n"


echo "\n ****** distrubute spec begin ****** \n"
#提示输入基础版本号
read -p "输入基础版本:如0.2.x，后续自增x" base_version
# 获取到的文件路径
file_path=""
file_name=""
# 文件后缀名
file_extension="podspec"
# 文件夹路径，pwd表示当前文件夹
directory="$(pwd)"
 
# 参数1: 路径；参数2: 文件后缀名
function getFileAtDirectory(){
    for element in `ls $1`
    do
        dir_or_file=$1"/"$element
        # echo "$dir_or_file"
        if [ -d $dir_or_file ]
        then
            getFileAtDirectory $dir_or_file
        else
            file_extension=${dir_or_file##*.}
            if [[ $file_extension == $2 ]]; then
                echo "$dir_or_file 是 $2 文件"
                file_path=$dir_or_file
                file_name=$element
            fi
        fi
    done
}
getFileAtDirectory $directory $file_extension
 
echo "\n file_path: ${file_path}"
echo "\n file_name: ${file_name}"
 
 
echo "\n ---- 读取podspec文件内容 begin ---- \n"
 
# 定义pod文件名称
pod_file_name=${file_name}
# 查找 podspec 的版本
search_str="s.version"
 
# 读取podspec的版本
podspec_version=""
pod_spec_version_new=""
 
#定义了要读取文件的路径
my_file="${pod_file_name}"
while read my_line
do
#输出读到的每一行的结果
# echo $my_line
 
    # 查找到包含的内容，正则表达式获取以 ${search_str} 开头的内容
    result=$(echo ${my_line} | grep "^${search_str}")
    if [[ "$result" != "" ]]
    then
           echo "\n ${my_line} 包含 ${search_str}"
 
           # 分割字符串，是变量名称，不是变量的值; 前面的空格表示分割的字符，后面的空格不可省略
        array=(${result// / })
        # 数组长度
        count=${#array[@]}
        # 获取最后一个元素内容
        version=${array[count - 1]}
        # 去掉 '
        version=${version//\'/}
 
        podspec_version=$version
    #else
           # echo "\n ${my_line} 不包含 ${search_str}"
    fi
 
done < $my_file
echo "\n podspec_version: ${podspec_version}"
 
 
pod_spec_name=${file_name}
pod_spec_version=${podspec_version}
 
echo "\n ---- 版本号自增 ---- \n"
increment_version ()
{
  declare -a part=( ${1//\./ } )
  declare    new
  declare -i carry=1
  CNTR=${#part[@]}-1
  len=${#part[CNTR]}
  new=$((part[CNTR]+carry))
  part[CNTR]=${new}
  new="${part[*]}"
  pod_spec_version_new=${new// /.}
}
increment_version $pod_spec_version
echo "\n podspec_version_new: ${pod_spec_version_new}"
 
LineNumber=`grep -nE 's.version.*=' ${pod_spec_name} | cut -d : -f1`
sed -i "" "${LineNumber}s/${podspec_version}/${pod_spec_version_new}/g" ${pod_spec_name}

git status
git add .
git commit "升级spec到${podspec_version}"
git push -f

git tag ${pod_spec_version_new}
git push origin master --tags

pod repo push GGZSpec ABC.podspec --allow-warnings --use-libraries --verbose

echo "\n ****** distrubute spec begin ****** \n"
