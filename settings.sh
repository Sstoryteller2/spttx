#!/bin/bash
clear
sed -i 's/[[:blank:]]*$//' data
echo 
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

token=0

while [[ $REPLY != [0-5]  ]]; do
	read -p "Выберите настройки:
1. Язык (русский, казахский): $lng
2. Числа: словами или цифрами: $nm
3. Обсценная лексика (мат): $obc
4. Время отложенного распознания: $dfdf $def_l $def_t
5. TOKEN $tok

0. Выход
"
	if [[ "$REPLY" =~ ^[0-5]$ ]]; then
		if [[ "$REPLY" == 0 ]]; then
			if [[ "$tok" != "yes" ]]; then
				echo "Без токена работать не будет"
			fi
			echo bye-bye
			break			
		fi
		
		if [[ "$REPLY" == 1 ]]; then
			REPLY=NULL
			while [[ $REPLY != [0-2] ]]; do
				read -p "Выберите язык:
			1. Русский
			2. Казахша

			0. Верунться
			"
				if [[ "$REPLY" =~ ^[0-2]$ ]]; then
					if [[ "$REPLY" == 0 ]]; then
						REPLY=NULL	
						break 
					fi
					if [[ "$REPLY" == 1 ]]; then
						sed -i "s/languageCode $lang/languageCode ru-RU/" data
						lng="(!русский)"
						echo "выбран русский язык"
						lang="ru-RU"
						REPLY=NULL				
						break;				
					fi
					if [[ "$REPLY" == 2 ]]; then
						sed -i "s/languageCode $lang/languageCode kk-KK/" data
						lang="kk-KK"
						lng="(!казахша)"
						echo "казахша бердым"
						REPLY=NULL				
						break;				
					fi
				else
					echo "введите числа от 0 до 2"
				fi
			done		
		fi
		if [[ "$REPLY" == 2 ]]; then
			REPLY=NULL
			while [[ $REPLY != [0-2] ]]; do
				read -p "Как отображать числа?
			1. Цифрами
			2. Словами

			0. Верунться
			"
				if [[ "$REPLY" =~ ^[0-2]$ ]]; then
					if [[ "$REPLY" == 0 ]]; then
						REPLY=NULL	
						break 
					fi
					if [[ "$REPLY" == 1 ]]; then
						sed -i "s/rawResults $nums/rawResults false/" data
						nums="false"
						nm="(!цифрами)"
						echo $nm
						REPLY=NULL				
						break;				
					fi
					if [[ "$REPLY" == 2 ]]; then
						sed -i "s/rawResults $nums/rawResults true/" data
						nums="true"
						nm="(!словами)"
						echo $nm						
						REPLY=NULL				
						break;				
					fi
				else
					echo "введите числа от 0 до 2"
				fi
			done		
		fi
		if [[ "$REPLY" == 3 ]]; then
			REPLY=NULL
			while [[ $REPLY != [0-2] ]]; do
				read -p "Материмся?
			1. Да, пусть будет с матом
			2. Нет, надо отфильтровать

			0. Верунться
			"
				if [[ "$REPLY" =~ ^[0-2]$ ]]; then
					if [[ "$REPLY" == 0 ]]; then
						REPLY=NULL	
						break 
					fi
					if [[ "$REPLY" == 1 ]]; then
						sed -i "s/profanityFilter $obsc/profanityFilter false/" data
						obsc="false"
						obc="(!мат вкл)"
						echo $nm
						REPLY=NULL				
						break;				
					fi
					if [[ "$REPLY" == 2 ]]; then
						sed -i "s/profanityFilter $obsc/profanityFilter true/" data
						obsc="true"
						obc="(!мат выкл)"
						echo $nm						
						REPLY=NULL				
						break;				
					fi
				else
					echo "введите числа от 0 до 2"
				fi
			done		
		fi
		if [[ "$REPLY" == 4 ]]; then
			REPLY=NULL
			while [[ $REPLY != [0-4] ]]; do
				read -p "Насколько задержать отложенное распознание?
			1. секунды
			2. минуты
			3. часы
			4. дни

			0. Верунться
			"
				if [[ "$REPLY" =~ ^[0-4]$ ]]; then
					if [[ "$REPLY" == 0 ]]; then
						REPLY=NULL				
						break 
					fi
					if [[ "$REPLY" == 1 ]]; then
						REPLY=NULL				
						def_ty="sec"
						break
					fi
					if [[ "$REPLY" == 2 ]]; then
						REPLY=NULL				
						def_ty="min"
						break
					fi
					if [[ "$REPLY" == 3 ]]; then
						REPLY=NULL				
						def_ty="hour"
						break;	
					fi
					if [[ "$REPLY" == 4 ]]; then
						REPLY=NULL				
						def_ty="days"
						break;				
					fi
				else
					echo "введите числа от 0 до 2"
				fi				
		
			done
			if [[ $def_ty ]]; then
				sed -i "s/def_t $def_t/def_t $def_ty/" data
				def_t=$def_ty
				while :; do
					echo  "Введите число от 1 до 60 "
					read num
					[[ $num =~ ^[0-9]+$ ]] || { echo "Enter a valid number"; continue; }	
					if (($num >= 1 && $num <= 60)); then
						sed -i "s/def_l $def_l/def_l $num/" data
						dfdf="!"
 						def_l=$num
				       		break	       
					fi
				done
			fi
		fi
		if [[ "$REPLY" == 5 ]]; then
			REPLY=NULL
			while [[ "$token" == "0" ]]; do
				echo  "вставьте токен (0 - вернуться)  "
				read token
				if [[ "$token" == "0" ]]; then
					tok="no"
					break;
				fi
				if [[  "$token" && "$token" != "0" ]]; then
					echo "токен добавлен"
					sed -i "s/key $key/key $token/" data
					tok="yes"	
					break			
				fi
			done
		fi
	else
		echo "введите числа от 0 до 4"
	fi
done

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
1. Язык (русский, казахский): $lng
2. Числа: словами или цифрами: $nm
3. Обсценная лексика (мат): $obc
4. Время отложенного распознания: $dfdf $def_l $def_t
5. TOKEN $tok
"
exit
