# spttx 
bash script for access to Yandex SpeechKit longRunningRecognize  Ubuntu

Скрипт для упрощения работы с сервисом Yandex SpeechKit распознание длинных аудио. 

Перед началом:
Чтобы скрипт работал нужно завести пользовательский аккаунт на Яндекс-облаке, создать бакет, создать сервисный аккаунт (https://cloud.yandex.ru/docs/speechkit/quickstart), <b>получить ключ API</b>. Это всё делается в интерфейсе Яндекс Облака. Положить на счёт денежку.

Для общения скрипта с этой инфраструктурой нужно ставить себе CLI Яндекса и Амазона:
CLI Yandex.Cloud: https://cloud.yandex.ru/docs/cli/
AWS CLI: https://cloud.yandex.ru/docs/storage/tools/aws-cli (это для работы с бакетом Яндекса)

Первый запуск:
Создаете папку (любую) скачиваете туда 4 файла, задайте разрешение на исполнение всех .sh. 
Запускаете ./settings прописываете API-KEY или можно вручную отредактировать файл data. Запускаете ./spttx 
Скрипт предложит создать папку logs (для хранения логов) и папки text и audio. Также скрипт проверит наличие ffmpeg (для конвертации аудио), pandoc (для сохранения результатов в док-файлы) и at (для работы отложенного распознания), если кто-то из них не установлен запустится sudo apt install. Так как папка audio пуста, скрипт предложит сложить туда файл и выключится.

Работа со скриптом:
В папку audio складываете файлы (названия лучше латиницей), запускаете скрипт, получаете готовый результат в папке text.

Запускаете скрипт ./spptx
На экране будут отображены настройки (язык, фильтр мата, отображение чисел, время отложенной конвертации и наличие ключа API)
Скрипт проверяет папку audio, если там больше 1 файла, предлагает выбрать, какой именно распознать. 
Выдаёт параметры файла (длительнсть, количество каналов, битрейт и др.), предлагает выбрать на сколько дорожек конвертировать (1-2 или оставить как в оригенале). Яндекс берет деньги за каждую дорожку.
Предлагается выбрать модель распознания, на данный момент доступны 4 штуки (для русского языка). Первые три распознают быстро, четвертый - отложенный, Яндекс обещает результат в течение суток, но пока скорость всех, одинаковая (4 в четыре раза дешевле).

Калькулятор выдаёт примерное время на распознание и цену конвертации. Начинается конвертация.
Скрипт спрашивает, разрешение на загрузку в облако и отправку запроса на распознание (за эти действия будут списываться деньги с вашего счёта).

Для первых трёх моделей, запуститься таймер, Яндекс обещает расшифровку в 10 раз быстрее хронометража оригинала. Т.е. часовой трек можно ждать через 6 минут.

Через расчётное время задержки будет отправлен запрос на получение результата, если он есть, то программа создаст документ док, и удалит все вспомгательные файлы (конвертированный аудио файл на локальном диске и в облаке, и все служебные файлы, кроме логов).

Если результат не готов, включится ещё один таймер на 10 секунд, и так будет продолжаться до получения результата (обычно на 2-3 повтор резльутат приходит). 

При выборе модели deferred-general скрипт создаёт отдельный исполняемый файл (шаблон deferred.sh), его запуск планируется на время стандартного исполнения (в десть раз быстрее хронометража) плюс время отоженного (по умолчанию 2 минуты), можно поменять. 

Когда наступает время исполнения скрипт запускается, если на сервере есть распознанный текст, он сохраняется и конвертируется в док, все служебные и вспомогательные файлы удаляются (в том числе сам скрипт). 

Настройки:
для изменеия настроек запустите файл ./settings
Доступны иземенения:
1. Язык (русский, казахский)
2. Числа: словами или цифрами
3. Фильтр обсценной лексики (включен или отключен) 
4. Время отложенного распознания:  можно выбрать секунды-минуты-часы-дни и колличество (от 1 до 60)
5. TOKEN - добавление токена.

