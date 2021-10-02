#!/bin/bash
clear
echo "Расшифровка звука"
sed -i 's/[[:blank:]]*$//' data
lang=$(grep "languageCode" data | sed 's/.* //')
if [[ "$lang" == "ru-RU" ]]; then
	lng="русский"
fi
if [[ "$lang" == "kk-KK" ]]; then
	lng="казахский"
fi
nums=$(grep "rawResults" data | sed 's/.* //')
if [[ "$nums" == "false" ]]; then
	nm="цифрами"
fi
if [[ "$nums" == "true" ]]; then
	nm="словами"
fi
obsc=$(grep "profanityFilter" data | sed 's/.* //')
if [[ "$obsc" == "false" ]]; then
	obc="мат вкл"
fi
if [[ "$obsc" == "true" ]]; then
	obc="мат выкл"
fi

def_t=$(grep "def_t" data | sed 's/.* //')
def_l=$(grep "def_l" data | sed 's/.* //')
key=$(grep "key" data | sed 's/.* //')

if [[ "$key" ]]; then
	tok="yes"
	else
		tok="no"
fi
echo "

Выбранные настройки:
1. Язык: $lng
2. Числа: $nm
3. Обсценная лексика (мат): $obc
4. Время отложенного распознания: $dfdf $def_l $def_t
5. TOKEN $tok

"

echo -n "проверка установки ffmpeg: "
if ! command -v ffmpeg &> /dev/null 
then
       echo "необходиму уставноить ffmpeg"
       sudo apt install ffmpeg       
else 
	echo "ok"
fi

echo -n "проверка установки at: "
if ! command -v at &> /dev/null 
then
       echo "необходиму уставноить at"
       sudo apt install at       
else 
	echo "ok"
fi

echo -n "проверка установки pandoc: "
if ! command -v pandoc &> /dev/null 
then
       echo "необходиму уставноить ffmpeg"
       sudo apt install pandoc       
else 
	echo "ok"
fi

echo -n "проверка папки audio: "
if ! [ -d audio/ ]; then
	while [[ $fold != "y" || $fold != "n" ]]; do
		echo -n "нет папки audio, создать? y/n: " & read fold;
		if [[ $fold == "y" ]]; then
			mkdir audio 
			echo "dir created, please put your audio to new folder and restart" 
			break;
		fi
		if [[ $fold == "n" ]]; then
			echo "без  папки не работает please create foder and put your audio there" 
			break;
		else
		       echo "type y or n"
		fi
	done
else 
	echo "ok"
fi

echo -n "проверка папки text: "
if ! [ -d text/ ]; then
	while [[ $fold != "y" || $fold != "n" ]]; do 
		echo -n "нет папки text, создать? y/n: " & read fold;
		if [[ $fold == "y" ]]; then
			mkdir text 
			echo "dir created, please restart" 
			break;
		fi
		if [[ $fold == "n" ]]; then
			echo "без  папки не работает please create foder" 
			break;
		else
		       echo "type y or n"
		fi
	done
else 
	echo "ok"
fi

echo -n "проверка папки logs: "
if ! [ -d logs/ ]; then
	while [[ $fold != "y" || $fold != "n" ]]; do 
		echo -n "нет папки text, создать? y/n: " & read fold;
		if [[ $fold == "y" ]]; then
			mkdir logs 
			echo "dir created, please restart" 
			break;
		fi
		if [[ $fold == "n" ]]; then
			echo "без  папки не работает please create foder" 
			break;
		else
		       echo "type y or n"
		fi
	done
else 
	echo "ok"
fi

if ! [ -f def_logs ]; then
	echo create def_logs
	touch def_logs
fi

# проверка файлов в папке аудио (если файл 1 в работу берется он, если несколько, нужно выбрать название)
file_count=$(ls audio/ | wc -l)
if [ $file_count = 0 ]; then  
	echo "no files in folder \"audio\", please put your file in folder" 
       	exit;
fi
if [ $file_count = 1 ]; then  
	file=$(ls audio/); 
	echo "файл в работе: "$file
else
       while ! [ -f audio/$file ]; do
	       echo "введите название файла (выбирайте из предложенных): " 
	       ls audio/ | cat -n
	       read fl
	       file=$(ls audio/ |cat -n | grep "^     $fl" |sed "s/^.* $fl.//")
	       echo "НАЗВАНИЕ ФАЙЛА: $file"
	       if ! [ -f audio/$file ]; then
		       echo "такого файла нет, попробуйте ещё раз"
	       fi
	       if [ -f audio/$file ]; then
		       break;
	       fi
       done
fi

#нужна проверка на доступы
chmod 775 audio/"$file"


echo 
# вывод данных файла
ffprobe -hide_banner audio/$file 2>&1 | grep "Duration\|Stream"
echo	
echo "______________^__________________" 	
echo выбирайте параметры дорожек вручную
#	ffprobe -hide_banner audio/$file
while [[ $chanl != "1" || $chanl != "2" || $chanl != "N" ]]; do 
	echo -n "Введите 1 или 2, (N - конвертировать как в исходном): " 
	read chanl 
	if [[ $chanl == "1" ]]; then
		break;
	fi
	if [[ $chanl == "2" ]]; then
		break;
	fi
	if [[ $chanl == "N" ]]; then
		break
	else
		echo "type 1 or 2 or N"
	fi	
done

echo 
echo
# название переменной для название аудио файла после конвертации
file_out=$(echo $file | cut -d "." -f1)
file_type=$(echo $file | cut -d'.' -f2)

#ее рассчитываем колличество секунд
chron=$(ffprobe -hide_banner audio/$file 2>&1 | grep -o -P 'Duration.{0,13}'| sed 's/^.*ion: //')
h=$(date --date="$chron" +"%-H")
m=$(date --date="$chron" +"%-M")
s=$(date --date="$chron" +"%-S")
let "seconds= ($h*3600 + $m*60 + $s)"

cost=$(bc -l <<< "scale=2; $seconds/100")

echo



echo
# коневертация файла
echo "Выберете модель распознания"
echo 1. hqa
echo 2. general
echo 3. general:rc
echo 4. deferred-general
echo 0. exit

while [[ $REPLY != [0-4] ]]; do
	read -p "Введите выбор [0-4] > "
	if [[ "$REPLY" =~ ^[0-4]$ ]]; then
		if [[ "$REPLY" == 0 ]]; then
			echo bye-bye
			exit
		fi
		if [[ "$REPLY" == 1 ]]; then
			model="hqa"
			echo "
			$model choosen"
		fi
		if [[ "$REPLY" == 2 ]]; then
			model="general"
			echo "
			$model choosen"
		fi
		if [[ "$REPLY" == 3 ]]; then
			model="general:rc"
			echo "
			$model choosen"
		fi
		if [[ "$REPLY" == 4 ]]; then
			model="deferred-general"
			echo "
			$model choosen"
		fi
	else
		echo "введите числа от 0 до 4"
	fi
done
echo

if [[ "$REPLY" =~ ^[1-3]$ ]]; then
	prc=0.01
fi
if [[ "$REPLY" == 4 ]]; then
	prc=0.0025
fi

echo "
минут на выполнение примерно: " $(bc -l <<< "scale=2; $seconds / 600"); 
date=$(date)

# расчет цены
price=$(bc -l <<< "scale=2; $prc * $seconds")

if [[ $chanl = "2" ]]; then
	echo "
	цена двойная (за каждый поток) лучше свести каналы:" $(bc -l <<< "scale=2; $price * 2") "руб."
fi
if [[ $chanl == "N" || $chanl == "1" ]]; then
	echo "
	цена за один канал: " $price
fi


# конвертация файла в формат либопус
while [[ $chanl != "1" || $chanl != "2" || $chanl != "N" ]]; do 
		if [[ $chanl == "1" ]]; then 
			echo "конвертируем в моно"
			sleep 5
			ffmpeg -i audio/$file \
	  			-hide_banner\
				-loglevel -8\
	  			-ac 1 \
	  			-c:a libopus \
	  			audio/$file_out"`date +"_%d-%m-%Y"`"_out_mn.opus;
				upload=$(echo $file_out"`date +"_%d-%m-%Y"`"_out_mn.opus);
			break;
		fi
		if [[ $chanl == "2" ]]; then
			echo "конвертируем в стерео"
			ffmpeg -i audio/$file \
				-hide_banner\
				-loglevel -8\
				-c:a libopus \
				audio/$file_out"`date +"_%d-%m-%Y"`"_out_st.opus;
				upload=$(echo $file_out"`date +"_%d-%m-%Y"`"_out_st.opus);
			break;
		fi
		if [[ $chanl == "N" ]]; then
			echo "оставляем как есть" 
			ffmpeg -i audio/$file \
				-c:a libopus \
				-loglevel -8\
				-hide_banner\
				audio/$file_out"`date +"_%d-%m-%Y"`"out_mn-or.opus;
				upload=$(echo $file_out"`date +"_%d-%m-%Y"`"out_mn-or.opus);
				break;
			else
				echo "type 1 or  2 or N"
		fi
	done
echo


chron=$(ffprobe -hide_banner audio/$upload 2>&1 | grep -o -P 'Duration.{0,13}'| sed 's/^.*ion: //')
file_size=$(stat -c%s "audio/$upload")
h=$(date --date="$chron" +"%-H")
m=$(date --date="$chron" +"%-M")
s=$(date --date="$chron" +"%-S")
let "seconds= ($h*3600 + $m*60 + $s)"

chanl=$(ffprobe -hide_banner audio/$file 2>&1 | grep -o mono)
if [[ $chanl == "mono" ]]; then
	chanl=1
else
	chanl=2
fi

# прогноз времени ответа на запрос на распознание (в 10 раз быстрее хронометража кроме отложенной модели)
let "slp=($seconds/10)"
echo $slp, $def_l, $def_t

# создаём файл для запроса params.json
#./bd-tm $upload $model

cat > params.json << -EOF
{
	"config": {
	"specification": {
			"languageCode": "$lang",
			"model": "$model",
            		"profanityFilter": "$obsc",
			"rawResults": "$nums"
		}
	},
	"audio": {
		"uri": "https://storage.yandexcloud.net/rash2/$upload"
	}
}
-EOF

# отправка файла в яндекс
while [[ $fold != "y" || $fold != "n" ]]; do
	echo -n "файл $upload конвертирован, загрузить и распознать? y/n "
	read fold
	if [[ $fold == "y" ]]; then 
		aws --endpoint-url=https://storage.yandexcloud.net \
			s3 cp audio/$upload s3://rash2/$upload
			check=$(aws --endpoint-url=https://storage.yandexcloud.net s3 ls --recursive s3://rash2 | grep -o $upload)
			if [[ $check == $upload ]]; then
				cloud=t
				upl_ts=$(date)
				echo "Файл в облалке"
			else
				echo "что пошло не так :(("
				cloud=f
				exit;
			fi
		break
	fi
		if [[ $fold == "n" ]]; then
			echo "Этап загрузки пропущен, нужно выбрать из списка файлов на диске";
			aws --endpoint-url=https://storage.yandexcloud.net s3 ls --recursive s3://rash2
			exit
			break;
		else
			echo "type y or n"
		fi
done



log_name=$(echo log_$file_out"`date +"_%d-%m-%Y_%H%M"`"_$model.txt)
curl -sX POST \
	-H "Authorization: Api-Key $key" \
    	-d '@params.json' \
	https://transcribe.api.cloud.yandex.net/speech/stt/v2/longRunningRecognize > logs/$log_name 
send=$(date)
id=$(grep 'id' logs/$log_name | sed 's/^.*: "//' | sed 's/",*$//')
echo "file out:" $file_out

#отложенная коневертация
if [[ $model == "deferred-general" ]]; then
	answ=$(date -d "now + $def_l $def_t" +'%H:%M')
	def_time=$(date -d "now + 1 min" +%H:%M)
	def_name=$(echo def_"`date +"%H%M_%d-%m-%Y"`".sh)
	cp deferred.sh $def_name
	sed -i "s/\$1/$id/" $def_name 
	sed -i "s/\$2/$file_out/" $def_name 
	sed -i "s/\$3/$upload/" $def_name 	
	sed -i "s/\$4/$def_name/" $def_name 
	sed -i "s/\$5/$def_t/" $def_name 
	sed -i "s/\$6/$def_l/" $def_name 
	sed -i "s/\$7/$key/" $def_name 
	path=$(realpath $def_name)
	curl -sH "Authorization: Api-Key $key" \
					https://operation.api.cloud.yandex.net/operations/$id > ready_tst
	ready=$(grep 'done' ready_tst | sed 's/^.*: //' | sed 's/,*$//')
	echo $path | at $answ
	echo "Сформирован скрипт $def_name, он будет автоматически запущен после $answ (можно запустить вручную раньше) "
	exit;
fi

# прогноз времени ответа на запрос на распознание (в 10 раз быстрее хронометража кроме отложенной модели)
let "slp=($seconds/10)"
echo "starting progress, est" $slp "sec.";
seconds=$slp; date1=$((`date +%s` + $seconds));
echo
while [ "$date1" -ge `date +%s` ]; do
  echo -ne "	$(date -u --date @$(($date1 - `date +%s` )) +%H:%M:%S)\r";
done
echo

curl -sH "Authorization: Api-Key $key" \
	https://operation.api.cloud.yandex.net/operations/$id > ready_tst

ready=$(grep 'done' ready_tst | sed 's/^.*: //' | sed 's/,*$//')
echo test status: $ready
if [[ $ready == "false" ]]; then
	while [[ $ready == "false" ]]; do
		curl -sH "Authorization: Api-Key $key" \
			https://operation.api.cloud.yandex.net/operations/$id > ready_tst
		ready=$(grep 'done' ready_tst | sed 's/^.*: //' | sed 's/,*$//')
		echo "Обработка не завершена, до следующего запроса: "
		seconds=10; date1=$((`date +%s` + $seconds));
		echo
		while [ "$date1" -ge `date +%s` ]; do 
			echo -ne "	$(date -u --date @$(($date1 - `date +%s` )) +%H:%M:%S)\r";
		done
	if [[ $ready == "true" ]]; then
		echo "ready"
		break
	fi
	seconds=10; date1=$((`date +%s` + $seconds));
	echo
	while [ "$date1" -ge `date +%s` ]; do
  	echo -ne "	$(date -u --date @$(($date1 - `date +%s` )) +%H:%M:%S)\r";
	done
	done
fi
echo
# преобразование итогового резульата в текстовый файл

out_txt=$(echo $file_out"`date +"_%d-%m-%Y_%H%M"`"_$model.txt)
out_docx=$(echo $file_out"`date +"_%d-%m-%Y_%H%M"`"_$model.docx)
grep "text" ready_tst | sed 's/^.*: "//' | sed 's/",*$//' | sed -e G > text/$out_txt
pandoc text/$out_txt -o text/$out_docx
echo "результат сохранён в файл" $out_docx
echo
echo "Конец итогового документа:
"
tail  text/$out_txt
echo
while [[ $fold != "y" || $fold != "n" ]]; do 
	echo -n "Если всё ок, Провести очистку (удалить конвертированный файл)? y/n " 
	read fold
	if [[ $fold == "n" ]]; then
		break;
	fi
	if [[ $fold == "y" ]]; then		
		aws --endpoint-url=https://storage.yandexcloud.net \
			s3 rm s3://rash2/$upload
		rm audio/$upload
		rm text/$out_txt
		break;
	else
		echo "type y or n"
	fi
done
echo
echo Всем спасибо, я свободен!
