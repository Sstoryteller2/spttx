# spttx 
bash script for access to Yandex SpeechKit longRunningRecognize Ubuntu

Скрипт для упрощения работы с сервисом Yandex SpeechKit распознание длинных аудио (работает на Ubuntu).
1. Складываете звуковой файл для распознания, 
2. Запускаете скрипт,
3. Получаете файл с распознанным текстом.


<H1> Перед началом:</H1>
Чтобы скрипт работал нужно завести пользовательский аккаунт на Яндекс-облаке, создать бакет, создать сервисный аккаунт, <b>получить ключ API</b>, положить на счёт денежку. Это всё делается в интерфейсе Яндекс Облака.

[Подробная инструкция по подключению от Яндекса](https://cloud.yandex.ru/docs/speechkit/quickstart) 

Для общения скрипта с этой инфраструктурой нужно ставить себе <b>CLI Яндекса</b> и <b>Амазона</b>:

[CLI Yandex.Cloud](https://cloud.yandex.ru/docs/cli/)

[AWS CLI](https://cloud.yandex.ru/docs/storage/tools/aws-cli) (это для работы с бакетом Яндекса)

<hr>
<H1> Первый запуск:</H1> 
Создаете папку (любую) распаковываете туда 4 файла, задайте разрешение на исполнение всех .sh. 

```bash
chmod 775 *.sh
```

Запускаете ./settings 
```bash
./settings.sh
```
прописываете API-KEY (выбираете 5 пункт в меню, вставляете API-KEY сервисного аккаунта Яндекса) либо можно вручную отредактировать файл data вставляйте через пробел после слова key. Задаёте имя облака в Яндекс облаке (пункт 6 в меню, или также вручную правьте data), без них работать не будет.

```bash
vim data
```
Запускаете ./spttx.sh
```bash
./spttx.sh
```
Скрипт предложит:
<li> создать папку logs (для хранения логов),
<li> папки text и audio,
<li> проверит наличие <b> ffmpeg</b> (для конвертации аудио), 
<li> <b>pandoc</b> (для сохранения результатов в док-файлы) 
<li> <b>at</b> (для работы отложенного распознания)
  
***если кто-то из них не установлен запустится sudo apt install. Так как папка audio пуста, скрипт предложит сложить туда файл и выключится.***
  
<hr>
<H1> Работа со скриптом:</H1> 

1. В папку audio складываете файл (названия лучше латиницей), 
2. Запускаете скрипт (в общей папке) 
```bash
./spttx.sh
```
3. получаете готовый результат в папке text.

Скрипт расчитан на работу с одиночными файлами. Т.е. для каждого нового файла, нужно запускать скрипт снова.
    
<H2> Подробнее </H2>  

[Принцип работы](https://habr.com/ru/post/583230/)

При запуске скрита на экране будут отображены настройки и результаты проверки папок:
  
```bash  
  Расшифровка звука

Выбранные настройки:
1. Язык: русский
2. Числа: словами
3. Обсценная лексика (мат): мат вкл
4. Время отложенного распознания:  10 min
5. TOKEN yes
6. Название облака (https://storage.yandexcloud.net/<baket-name>/) <baket-name>

проверка установки ffmpeg: ok
проверка установки at: ok
проверка установки pandoc: ok
проверка папки audio: ok
проверка папки text: ok
проверка папки logs: ok
```
  
  
После скрипт проверяет папку audio, если там больше 1 файла, предлагает выбрать, какой именно распознать. 
 
Выдаёт параметры файла (длительнсть, количество каналов, битрейт и др.), предлагает выбрать на сколько дорожек конвертировать (1-2 или оставить как в оригинале). Яндекс берет деньги за каждую дорожку.
 
```bash
  НАЗВАНИЕ ФАЙЛА: ####.mp3

  Duration: 00:05:29.16, start: 0.000000, bitrate: 32 kb/s
    Stream #0:0: Audio: mp3, 48000 Hz, mono, fltp, 32 kb/s

______________^__________________
выбирайте параметры дорожек вручную
Введите 1 или 2, (N - конвертировать как в исходном):
```
  
Предлагается выбрать модель распознания, на данный момент доступны 4 штуки (для русского языка). Первые три распознают быстро, четвертый - отложенный (Яндекс обещает результат в течение суток), но пока скорость всех, одинаковая, цена разная, отложенная модель 4 в четыре раза дешевле.
  
Калькулятор выдаёт примерное время на распознание и цену конвертации. Начинается конвертация.

```bash
  Выберете модель распознания
1. hqa
2. general
3. general:rc
4. deferred-general
0. exit
Введите выбор [0-4] > 4

			deferred-general choosen


минут на выполнение примерно:  .54

	цена за один канал:  .8225
оставляем как есть
```

Далее скрипт спрашивает, разрешение на загрузку в облако и отправку запроса на распознание (за эти действия будут списываться деньги с вашего счёта).

Для первых трёх моделей, запустится таймер, Яндекс обещает расшифровку в 10 раз быстрее хронометража оригинала. Т.е. часовой трек можно ждать через 6 минут.

Через расчётное время задержки будет отправлен запрос на получение результата, если он есть, то программа создаст документ док, и удалит все вспомгательные файлы (конвертированный аудио файл на локальном диске и в облаке, и все служебные файлы, кроме логов).

Если результат не готов, включится ещё один таймер на 10 секунд, и так будет продолжаться до получения результата (обычно на 2-3 повтор резльутат приходит). 

При выборе модели deferred-general скрипт создаёт отдельный исполняемый файл (шаблон deferred.sh), его запуск планируется на время стандартного исполнения (в десть раз быстрее хронометража) плюс время отложенного (по умолчанию 2 минуты), можно поменять. 

Когда наступает время исполнения скрипт запускается, если на сервере есть распознанный текст, он сохраняется и конвертируется в док, все служебные и вспомогательные файлы удаляются (в том числе сам скрипт). 
<hr>
<H1> Настройки:</H1> 
для изменеия настроек запустите файл ./settings

```bash
./settings.sh
```
	
Доступны изменения:
1. Языки русский, казахский
2. Числа: словами или цифрами
3. Фильтр обсценной лексики (включен или отключен) 
4. Время отложенного распознания:  можно выбрать секунды-минуты-часы-дни и колличество (от 1 до 60) 
5. TOKEN - добавление токена.
6. Название облака - адрес бакета, куда загружать файл
	
	<H1>PS</H1>
Предложенный скрипт - индивидуальный, чтобы его масштабривать, можно добавить базу данных, модуль авторизации, и в целом, одним аккаунтом может пользваться довольно большие коллективы. Реализуется очень несложно.
