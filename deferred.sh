#!/bin/bash

id=$1
file_out=$2
upload=$3
def_name=$4
def_t=$5
def_l=$6
path=$(realpath $def_name)
pth_log=$(realpath def_logs)
pth=$(pwd)

curl -sH "Authorization: Api-Key AQVN2gg0Y6LodEc6Rh4QG1iWIMA1DsvXsowiP6o3" \
	https://operation.api.cloud.yandex.net/operations/$id > $pth/ready_tst
ready=$(grep 'done' ready_tst | sed 's/^.*: //' | sed 's/,*$//')
if [[ $ready == "false" ]]; then
	answ=$(date -d "now + $def_l $def_t" +'%H:%M')
	date >> $pth_log
	echo $ready Не готово, след запуск $answ >> $pth_log 
	echo $path | at $answ 2>> $pth_log
fi
out_txt=$(echo $file_out"`date +"_%d-%m-%Y_%H%M"`"_deferr.txt)
out_docx=$(echo $file_out"`date +"_%d-%m-%Y_%H%M"`"_$model.docx)
if [[ $ready == "true" ]]; then 
	date >> $pth_log
	grep "text" ready_tst | sed 's/^.*: "//' | sed 's/",*$//' | sed -e G > text/$out_txt
	pandoc $pth/text/$out_txt -o $pth/text/$out_docx
	echo "результат сохранён в файл" $out_docx >> $pth_log
	aws --endpoint-url=https://storage.yandexcloud.net s3 rm s3://rash2/$upload
	rm $pth/audio/$upload
	rm $pth/text/$out_txt
	rm $pth/ready_tst
	rm $pth/$def_name
fi
