### Нагрузочное тестирование с помощью yandex-tank

Нагрузочное тестирование часто не проводят и метрики получают уже на prod c помощью средств мониторинга (н.п. Grafana). Вопросы типа "Что будет при возросшей нагрузке?" остаются в стороне. И с другой стороны нагрузочное тестирование может показать узкие места при различных сценариях.  

Здесь описан только один из примеров настройки теста [Yandex-tank](https://github.com/yandex/yandex-tank). 

Сам yandex-tank крутится в Docker. Скрипт для проведения теста [./tank_run_shop_kotlin.sh](tank_run_shop_kotlin.sh):

````shell
docker run --entrypoint yandex-tank \
    -v /home/vasi/prog/kotlin/shop/shop_kotlin_yandex_tank_test/ammo:/var/loadtest \
    --net host \
    -it direvius/yandex-tank

````

Для проведения теста папка <i><b>./ammo</b></i> подключается к docker образу по пути <i><b>/var/loadtest</b></i>. По этому пути (<i><b>/var/loadtest</b></i>) yandex-tank будет искать настройки теста.  

В папке <i><b>/var/loadtest</b></i> 3 файла:
- token.txt - токен для публикации для публикации результатов в сервисе yandex-tank. Токен выдается при регистрации в сервисе.
- load.yaml - задание параметров нагрузки
- ammo-uri.txt - расстреливаемый URI (<i>/api/echo/aaa</i>) без адреса сервиса (<i>http://127.0.0.1:8780)

Файл load.yaml: 

````shell
overload:
    enabled: true
    package: yandextank.plugins.DataUploader
    token_file: "token.txt" #токен для публикации результатов в сервисе yandex-tank. Токен выдается при регистрации в сервисе
phantom:
    address: 127.0.0.1:8780 #адрес тестируемого сервиса 127.0.0.1:8780.
    load_profile: # описание нагрузки
        load_type: rps #тип нагрузки: "rps" - количество запросов в секунду, "matrix" - матричная нагрузка 
        schedule: const(1000, 1m) # нагрузка постоянная (const) 1000 rps в течении 1 минуты
    ammofile: /var/loadtest/ammo-uri.txt # по какому REST (без адреса сервера) стреляем ("/api/echo/aaa")
    ammo_type: uri 
console:
    enabled: true # показывать картинку проведения теста
telegraf:
    enabled: false

````
