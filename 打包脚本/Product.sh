#!/bin/bash

echo "--------------------------------------------------------------------------------"
echo "注意切换网络，本脚需要内网拉代码"
echo "--------------------------------------------------------------------------------"

#此处输入你的工程名字
project_name=""
project_extension="xcworkspace"

current_path=$PWD
echo "\n ------ 当前目录  ${current_path} ------ \n"
echo "\n ------ 查找xcworkspace文件开始 ------ \n"

for element in `ls ${current_path}`
do
subString=${element: 0-11: 11}
echo $subString
if [[ $subString  = "xcworkspace" ]]
then
project_name=${element%%.*}
fi
done

if [[ $project_name = "" ]]
then
exit
else
echo "找到xcworkspace 文件  $project_name"
fi

project_workspace=$project_name"."$project_extension

echo "--------------------------------------------------------------------------------"
echo "Please enter the scheme you want to build ?  这里只需输入后缀即可"
echo "--------------------------------------------------------------------------------"

read project_scheme_subString

project_scheme="${project_name}_$project_scheme_subString"
if [[ $project_scheme_subString = "" ]]
then
project_scheme=${project_name}
else
echo "找到xcworkspace 文件  $project_name"
fi



build_type=Release

archive_path="./ProductFile/${project_scheme}.xcarchive"

echo "--------------------------------------------------------------------------------"
echo "Please enter the path you want to save the .ipa ? 如果路径不存在将创建"
echo "--------------------------------------------------------------------------------"

read export_ipa_path

if [ ! -d "$export_ipa_path" ];then
mkdir $export_ipa_path
echo "创建文件夹成功"
else
echo "文件夹已存在"
fi

export_options_plist="./ProductFile/ExportOptions.plist"

echo "--------------------------------------------------------------------------------"
echo "project_scheme -----------  $project_scheme"
echo "archive_path -----------  $archive_path"
echo "export_ipa_path -----------  $export_ipa_path"
echo "export_options_plist -----------  $export_options_plist"
echo "--------------------------------------------------------------------------------"

echo "///--------------"
echo "/// 切换拉取代码网络"
echo "///--------------"

networksetup -setairportnetwork en0 ceshi-8f-10f cz@57863

pod update

echo "///--------------"
echo "/// 切换打包网络"
echo "///--------------"
networksetup -setairportnetwork en0 CZCB-5G Abcd1234

echo "///-----------"
echo "/// 正在清理工程"
echo "///-----------"

xcodebuild clean -workspace ${project_workspace} -scheme ${project_scheme} -configuration ${build_type} -quiet || exit

echo "///-----------"
echo "/// 正在编译工程"
echo "///-----------"

xcodebuild archive -workspace ${project_workspace} -scheme ${project_scheme} -configuration ${build_type} -archivePath ${archive_path} || exit

echo "///-----------"
echo "/// 开始导出ipa"
echo "///-----------"

xcodebuild -exportArchive -archivePath ${archive_path} -exportPath ${export_ipa_path} -exportOptionsPlist ${export_options_plist} -quiet || exit

if [[ -e ${export_ipa_path}/${project_scheme}.ipa ]]; then
echo "///-----------"
echo "/// ipa包已导出"
echo "///-----------"
open ${export_ipa_path}
fi
