#!/bin/bash


#当前版本为不从远程拉取最新代码，因为拉取代码需要换内网拉取
echo "--------------------------------------------------------------------------------"
echo "请确保本地代码为最新,本地证书也更新过，如果"
echo "--------------------------------------------------------------------------------"


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


#先注释掉，需要上传ipa
#pod update

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

if [[ ${project_scheme_subString} = "sit" ]]; then
curl -F "file=@${export_ipa_path}/${project_scheme}.ipa" -F "uKey=a00fd90ceaf2226d5559ff2a5a85d714" -F "_api_key=cdaeb2113c2984aff07818f4e1cd59d5" https://upload.pgyer.com/apiv1/app/upload
fi

#if [[ ${project_scheme_subString} = "uat" ]]; then
#curl -F "file=@${export_ipa_path}/${project_scheme}.ipa" -F "uKey=a00fd90ceaf2226d5559ff2a5a85d714" -F "_api_key=cdaeb2113c2984aff07818f4e1cd59d5" https://upload.pgyer.com/apiv1/app/upload
#fi




