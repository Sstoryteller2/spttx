#!/bin/bash
clear
echo 
lng="(русский)"
nm="(цифрами)"
obc="(мат вкл)"
def1="sec"
def2=70

while [[ $REPLY != [0-4] ]]; do
	read -p "Выберите настройки:
1. Язык (русский, казахский): $lng
2. Числа: словами или цифрами: $nm
3. Обсцентаня лексика (мат): оставлять или уирать $obc
4. Время отложенного расознанияш: $def2 $def1

0. Выход
"
	if [[ "$REPLY" =~ ^[0-4]$ ]]; then
		if [[ "$REPLY" == 0 ]]; then
			echo bye-bye
			exit
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
						lang="ru-RU"
						lng="(!русский)"
						echo "выбран русский язык"
						REPLY=NULL				
						break;				
					fi
					if [[ "$REPLY" == 2 ]]; then
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
						nums="false"
						nm="(!цифрами)"
						echo $nm
						REPLY=NULL				
						break;				
					fi
					if [[ "$REPLY" == 2 ]]; then
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
						obsc="false"
						obc="(!мат вкл)"
						echo $nm
						REPLY=NULL				
						break;				
					fi
					if [[ "$REPLY" == 2 ]]; then
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
						def1="sec"
						echo -n "Введите количество секунд: "
						read def2
						echo $def2 $def1
						

						break;				
					fi
					if [[ "$REPLY" == 2 ]]; then
						REPLY=NULL				
						def1="min"
						echo -n "Введите количество минут: "
						read def2
						echo $def2 $def1
						break;				
					fi
					if [[ "$REPLY" == 3 ]]; then
						REPLY=NULL				
						def1="hour"
						echo -n "Введите количество часов: "
						read def2
						if [[ $def2 =~ ^[0-60]$ ]]; then
							echo $def2 $def1
							break;			
						break;
					break;
				break;
						else
							echo "введите число от 1 до 60"
							
						fi
					fi
					if [[ "$REPLY" == 4 ]]; then
						REPLY=NULL				
						def1="days"

						echo -n "Введите количество дней: "
						read def2
						echo $def2 $def1
						break;				
					fi
				else
					echo "введите числа от 0 до 2"
				fi
			done		
			echo ok
		fi
	else
		echo "введите числа от 0 до 4"
	fi
done

