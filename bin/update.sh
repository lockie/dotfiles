#!/bin/sh
#update for gentoo
export XAUTHORITY="/home/lock/.Xauthority"
export DISPLAY=":0"
#Это, чтобы в иксы пробиться
eix-sync -C --quiet
#Овчинка, которую мы и выделываем
/home/lock/bin/notify.sh "Обновление" "Portage обновлены до "$(date)". Доступно "$(emerge -pavuDN world | grep -c - )" обновлений. Не забудьте выполнить emerge -uDNva world!" 60000 normal /usr/share/icons/gnome/256x256/status/dialog-information.png transfer.complete || /usr/local/bin/notify.sh "Обновление" "Обновление Portage завершилось неудачей" 60000 critical /usr/share/icons/gnome/256x256/status/dialog-error.png transfer.error;
#Мессага!
