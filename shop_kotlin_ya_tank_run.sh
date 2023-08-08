docker run --entrypoint yandex-tank \
    -v /home/vasi/prog/kotlin/shop/shop_kotlin_yandex_tank_test/ammo:/var/loadtest \
    --net host \
    -it direvius/yandex-tank
