#!/usr/bin/env bash

# This file will finalize the BibOS installation by installing the things which
# could not be preinstalled on the BibOS image. 
# This includes:
#
# * Printer and other hardware setup
# * Proprietary packages which we're not allowed to distribute
# * Registration to admin system.
# 
# This script REQUIRES AN INTERNET CONNECTION!

# Get proxy-environment if needed
source /usr/share/bibos/env/proxy.sh

# The script should be run as a sudo-enabled user - not directly as root.

zenity --info --text="Konfigurér printere i den efterfølgende dialog\nLuk dialogen for at fortsætte installationen"

# Printer setup
sudo system-config-printer

# Proprietary stuff

# Ensure Internet connection 

zenity --info --text="Du har brug for en forbindelse til Internettet for at fortsætte"      

# 1. Codecs, Adobe Flash, etc.

zenity --question  --text="Installér Adobe Flash og Microsoft fonts?"

if [[  $? -eq 0 ]]
then 
    # User pressed "Yes"
    sudo apt-get update
    sudo apt-get -y install ubuntu-restricted-extras 
fi


# 2. Skype

zenity --question --text="Installér Skype?"

if [[ $? -eq 0 ]]
then
     ATTEMPTED_INSTALL=1
     sudo add-apt-repository "deb http://archive.canonical.com/ $(lsb_release -sc) partner"
     sudo apt-get update  
     sudo apt-get -y install skype 
fi

if [[ ! -z $ATTEMPTED_INSTALL ]]
then

    if [[ $? -eq 0 ]]
    then
        zenity --info --text="Skype er installeret!"
    else
        zenity --error --text="Skype-installationen mislykkedes! Prøv eventuelt at\
            installere den manuelt fra Ubuntu Software Center."
    fi
fi

# 3. Google Chrome (real deal, no Chromium)

zenity --question --text="Installér Google Chrome?"

if [[ $? -eq 0 ]] 
then
    # Install it.
    # Follow procedure described here:
    # http://www.howopensource.com/2011/10/install-google-chrome-in-ubuntu-11-10-11-04-10-10-10-04/
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
    sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
    sudo apt-get update
    sudo apt-get -y install google-chrome-stable

# Make default browser globally
sudo update-alternatives --set x-www-browser /usr/bin/google-chrome

# Make default browser for user
cat << EOF > /tmp/mimeapps.list


[Default Applications]
text/html=google-chrome.desktop
x-scheme-handler/http=google-chrome.desktop
x-scheme-handler/https=google-chrome.desktop
x-scheme-handler/about=google-chrome.desktop
x-scheme-handler/unknown=google-chrome.desktop

EOF

sudo mkdir -p /home/.skjult/.local/share/applications
sudo mv /tmp/mimeapps.list /home/.skjult/.local/share/applications

   # Install desktop icon

cat << EOF > /tmp/google-chrome.desktop
[Desktop Entry]
Version=1.0
Name=Google Chrome
# Only KDE 4 seems to use GenericName, so we reuse the KDE strings.
# From Ubuntu's language-pack-kde-XX-base packages, version 9.04-20090413.
GenericName=Web Browser
GenericName[ar]=متصفح الشبكة
GenericName[bg]=Уеб браузър
GenericName[ca]=Navegador web
GenericName[cs]=WWW prohlížeč
GenericName[da]=Browser
GenericName[de]=Web-Browser
GenericName[el]=Περιηγητής ιστού
GenericName[en_GB]=Web Browser
GenericName[es]=Navegador web
GenericName[et]=Veebibrauser
GenericName[fi]=WWW-selain
GenericName[fr]=Navigateur Web
GenericName[gu]=વેબ બ્રાઉઝર
GenericName[he]=דפדפן אינטרנט
GenericName[hi]=वेब ब्राउज़र
GenericName[hu]=Webböngésző
GenericName[it]=Browser Web
GenericName[ja]=ウェブブラウザ
GenericName[kn]=ಜಾಲ ವೀಕ್ಷಕ
GenericName[ko]=웹 브라우저
GenericName[lt]=Žiniatinklio naršyklė
GenericName[lv]=Tīmekļa pārlūks
GenericName[ml]=വെബ് ബ്രൌസര്‍
GenericName[mr]=वेब ब्राऊजर
GenericName[nb]=Nettleser
GenericName[nl]=Webbrowser
GenericName[pl]=Przeglądarka WWW
GenericName[pt]=Navegador Web
GenericName[pt_BR]=Navegador da Internet
GenericName[ro]=Navigator de Internet
GenericName[ru]=Веб-браузер
GenericName[sl]=Spletni brskalnik
GenericName[sv]=Webbläsare
GenericName[ta]=இணைய உலாவி
GenericName[th]=เว็บเบราว์เซอร์
GenericName[tr]=Web Tarayıcı
GenericName[uk]=Навігатор Тенет
GenericName[zh_CN]=网页浏览器
GenericName[zh_HK]=網頁瀏覽器
GenericName[zh_TW]=網頁瀏覽器
# Not translated in KDE, from Epiphany 2.26.1-0ubuntu1.
GenericName[bn]=ওয়েব ব্রাউজার
GenericName[fil]=Web Browser
GenericName[hr]=Web preglednik
GenericName[id]=Browser Web
GenericName[or]=ଓ୍ବେବ ବ୍ରାଉଜର
GenericName[sk]=WWW prehliadač
GenericName[sr]=Интернет прегледник
GenericName[te]=మహాతల అన్వేషి
GenericName[vi]=Bộ duyệt Web
# Gnome and KDE 3 uses Comment.
Comment=Access the Internet
Comment[ar]=الدخول إلى الإنترنت
Comment[bg]=Достъп до интернет
Comment[bn]=ইন্টারনেটটি অ্যাক্সেস করুন
Comment[ca]=Accedeix a Internet
Comment[cs]=Přístup k internetu
Comment[da]=Få adgang til internettet
Comment[de]=Internetzugriff
Comment[el]=Πρόσβαση στο Διαδίκτυο
Comment[en_GB]=Access the Internet
Comment[es]=Accede a Internet.
Comment[et]=Pääs Internetti
Comment[fi]=Käytä internetiä
Comment[fil]=I-access ang Internet
Comment[fr]=Accéder à Internet
Comment[gu]=ઇંટરનેટ ઍક્સેસ કરો
Comment[he]=גישה אל האינטרנט
Comment[hi]=इंटरनेट तक पहुंच स्थापित करें
Comment[hr]=Pristup Internetu
Comment[hu]=Internetelérés
Comment[id]=Akses Internet
Comment[it]=Accesso a Internet
Comment[ja]=インターネットにアクセス
Comment[kn]=ಇಂಟರ್ನೆಟ್ ಅನ್ನು ಪ್ರವೇಶಿಸಿ
Comment[ko]=인터넷 연결
Comment[lt]=Interneto prieiga
Comment[lv]=Piekļūt internetam
Comment[ml]=ഇന്റര്‍‌നെറ്റ് ആക്‌സസ് ചെയ്യുക
Comment[mr]=इंटरनेटमध्ये प्रवेश करा
Comment[nb]=Gå til Internett
Comment[nl]=Verbinding maken met internet
Comment[or]=ଇଣ୍ଟର୍ନେଟ୍ ପ୍ରବେଶ କରନ୍ତୁ
Comment[pl]=Skorzystaj z internetu
Comment[pt]=Aceder à Internet
Comment[pt_BR]=Acessar a internet
Comment[ro]=Accesaţi Internetul
Comment[ru]=Доступ в Интернет
Comment[sk]=Prístup do siete Internet
Comment[sl]=Dostop do interneta
Comment[sr]=Приступите Интернету
Comment[sv]=Gå ut på Internet
Comment[ta]=இணையத்தை அணுகுதல்
Comment[te]=ఇంటర్నెట్‌ను ఆక్సెస్ చెయ్యండి
Comment[th]=เข้าถึงอินเทอร์เน็ต
Comment[tr]=İnternet'e erişin
Comment[uk]=Доступ до Інтернету
Comment[vi]=Truy cập Internet
Comment[zh_CN]=访问互联网
Comment[zh_HK]=連線到網際網路
Comment[zh_TW]=連線到網際網路
Exec=/opt/google/chrome/google-chrome %U
Terminal=false
Icon=google-chrome
Type=Application
Categories=Network;WebBrowser;
MimeType=text/html;text/xml;application/xhtml_xml;x-scheme-handler/http;x-scheme-handler/https;x-scheme-handler/ftp;
X-Ayatana-Desktop-Shortcuts=NewWindow;NewIncognito

[NewWindow Shortcut Group]
Name=New Window
Name[am]=አዲስ መስኮት
Name[ar]=نافذة جديدة
Name[bg]=Нов прозорец
Name[bn]=নতুন উইন্ডো
Name[ca]=Finestra nova
Name[cs]=Nové okno
Name[da]=Nyt vindue
Name[de]=Neues Fenster
Name[el]=Νέο Παράθυρο
Name[en_GB]=New Window
Name[es]=Nueva ventana
Name[et]=Uus aken
Name[fa]=پنجره جدید
Name[fi]=Uusi ikkuna
Name[fil]=New Window
Name[fr]=Nouvelle fenêtre
Name[gu]=નવી વિંડો
Name[hi]=नई विंडो
Name[hr]=Novi prozor
Name[hu]=Új ablak
Name[id]=Jendela Baru
Name[it]=Nuova finestra
Name[iw]=חלון חדש
Name[ja]=新規ウインドウ
Name[kn]=ಹೊಸ ವಿಂಡೊ
Name[ko]=새 창
Name[lt]=Naujas langas
Name[lv]=Jauns logs
Name[ml]=പുതിയ വിന്‍ഡോ
Name[mr]=नवीन विंडो
Name[nl]=Nieuw venster
Name[no]=Nytt vindu
Name[pl]=Nowe okno
Name[pt]=Nova janela
Name[pt_BR]=Nova janela
Name[ro]=Fereastră nouă
Name[ru]=Новое окно
Name[sk]=Nové okno
Name[sl]=Novo okno
Name[sr]=Нови прозор
Name[sv]=Nytt fönster
Name[sw]=Dirisha Jipya
Name[ta]=புதிய சாளரம்
Name[te]=క్రొత్త విండో
Name[th]=หน้าต่างใหม่
Name[tr]=Yeni Pencere
Name[uk]=Нове вікно
Name[vi]=Cửa sổ Mới
Name[zh_CN]=新建窗口
Name[zh_TW]=開新視窗
Exec=/opt/google/chrome/google-chrome
TargetEnvironment=Unity

[NewIncognito Shortcut Group]
Name=New Incognito Window
Name[ar]=نافذة جديدة للتصفح المتخفي
Name[bg]=Нов прозорец „инкогнито“
Name[bn]=নতুন ছদ্মবেশী উইন্ডো
Name[ca]=Finestra d'incògnit nova
Name[cs]=Nové anonymní okno
Name[da]=Nyt inkognitovindue
Name[de]=Neues Inkognito-Fenster
Name[el]=Νέο παράθυρο για ανώνυμη περιήγηση
Name[en_GB]=New Incognito window
Name[es]=Nueva ventana de incógnito
Name[et]=Uus inkognito aken
Name[fa]=پنجره جدید حالت ناشناس
Name[fi]=Uusi incognito-ikkuna
Name[fil]=Bagong Incognito window
Name[fr]=Nouvelle fenêtre de navigation privée
Name[gu]=નવી છુપી વિંડો
Name[hi]=नई गुप्त विंडो
Name[hr]=Novi anoniman prozor
Name[hu]=Új Inkognitóablak
Name[id]=Jendela Penyamaran baru
Name[it]=Nuova finestra di navigazione in incognito
Name[iw]=חלון חדש לגלישה בסתר
Name[ja]=新しいシークレット ウィンドウ
Name[kn]=ಹೊಸ ಅಜ್ಞಾತ ವಿಂಡೋ
Name[ko]=새 시크릿 창
Name[lt]=Naujas inkognito langas
Name[lv]=Jauns inkognito režīma logs
Name[ml]=പുതിയ വേഷ പ്രച്ഛന്ന വിന്‍ഡോ
Name[mr]=नवीन गुप्त विंडो
Name[nl]=Nieuw incognitovenster
Name[no]=Nytt inkognitovindu
Name[pl]=Nowe okno incognito
Name[pt]=Nova janela de navegação anónima
Name[pt_BR]=Nova janela anônima
Name[ro]=Fereastră nouă incognito
Name[ru]=Новое окно в режиме инкогнито
Name[sk]=Nové okno inkognito
Name[sl]=Novo okno brez beleženja zgodovine
Name[sr]=Нови прозор за прегледање без архивирања
Name[sv]=Nytt inkognitofönster
Name[ta]=புதிய மறைநிலைச் சாளரம்
Name[te]=క్రొత్త అజ్ఞాత విండో
Name[th]=หน้าต่างใหม่ที่ไม่ระบุตัวตน
Name[tr]=Yeni Gizli pencere
Name[uk]=Нове вікно в режимі анонімного перегляду
Name[vi]=Cửa sổ ẩn danh mới
Name[zh_CN]=新建隐身窗口
Name[zh_TW]=新增無痕式視窗
Exec=/opt/google/chrome/google-chrome --incognito
TargetEnvironment=Unity
EOF

sudo mv /tmp/google-chrome.desktop /home/.skjult/Desktop
fi

# 4. Register in admin system

zenity --question  --text="Tilslut admin-systemet?"

if [[  $? -eq 0 ]]
then 
    # User pressed "Yes"
    register_new_bibos_client.sh
else
    zenity --info --text="Kør 'register_new_bibos_client.sh' hvis du vil tilslutte senere"
fi

if [[ -f /etc/lightdm/lightdm.conf.bibos ]]
then
    # Modify /etc/lightdm/lightdm.conf to avoid automatic user login
    sudo mv /etc/lightdm/lightdm.conf.bibos /etc/lightdm/lightdm.conf
fi

if [[ -f /etc/bibos/firstboot ]]
then
    # Add bibos started requirement to lightdm upstart script
    # TODO-CA: What is this? 
    grep "and started bibos" /etc/init/lightdm.conf > /dev/null
    if [ $? -ne 0 ]; then
        cat /etc/init/lightdm.conf | \
            perl -ne 's/and started dbus/and started dbus\n           and started bibos/;print' \
            > /tmp/lightdm.conf.tmp
        sudo mv /tmp/lightdm.conf.tmp /etc/init/lightdm.conf
    fi
    sudo rm /etc/bibos/firstboot
else
    zenity --warning --text="Dette er ikke en nyinstalleret BIBOS-maskine - opstarten ændres ikke.\n Lav en 'touch /etc/bibos/firstboot' og kør scriptet igen, hvis dette er en fejl."
fi


zenity --info --text="Installationen er afsluttet."
    
# Delete desktop file

DESKTOP_FILE=/home/superuser/Skrivebord/bibos-postinstall.desktop
if [[ -f $DESKTOP_FILE ]]
then
    sudo rm $DESKTOP_FILE
fi
