#!/bin/sh

REVDATE="2013.08.13"
VERSION="1.1"

impath=/usr/share/scim
destpath=$impath/tables
iconpath=$impath/icons

curpath=`dirname "$0"`

UseUTF8() {
    S_PRESS_Y_OR_N="請輸入 y 或 n ..."

    S_COPY="複製"
    S_DONE="完成"
    S_FAILED="失敗"

    S_MISSSOURCE="檔案來源遺失！"

    S_PRESS_ENTER_QUIT="(請按 Enter 鍵結束...)"

    S_EULA="本安裝套件係由教育部開發，免費供公眾散布使用。使用者可以免費下載、使用、重製、散布本安裝套件，惟重製和散布時，必須保持本安裝套件完整。使用者如為下載、使用、重製、散布以外之其他目的，須先得到教育部之書面授權，惟本安裝套件之任何使用目的均不得涉及主要為獲取商業利益或私人金錢報酬之方式。若因使用本軟體所產生之任何損害，本部一概不負任何責任。"

    S_REVDATE="釋出日期： $REVDATE"
    S_VERSION="表格檔版本： $VERSION"

    S_INFO="本安裝程序將為您安裝 教育部客家語拼音輸入法 SCIM 表格檔及其相關圖示檔\n(安裝過程中可能會要求您輸入目前使用者的登入密碼)"
    S_DESTPATH="表格安裝路徑"
    S_ICONPATH="圖示安裝路徑"

    S_CONFIRMINSTALL="您是否確定要安裝？"
    S_ABORT="安裝已中斷！"

    S_NOMODULE="找不到 $impath 路徑，您可能尚未安裝 SCIM 模組！"
    S_NOTDEFAULT="您目前的預設輸入法引擎並非是 SCIM，是否仍然要安裝？"

    S_NEEDROOT="本程序必須存取 /usr 目錄，而您目前的使用者權限不足！\n請試著登入 root 帳戶再重新操作一次"

    S_CANNOTREMOVE="無法移除舊的 教育部客家語拼音輸入法 SCIM 表格檔，已取消安裝！"

    S_FINISH="安裝結束！\n請重新啟動 SCIM 模組，或者重新登入系統"
}

UseEng() {
    S_PRESS_Y_OR_N="Press 'y' or 'n' ..."

    S_COPY="Copy"
    S_DONE="done"
    S_FAILED="failed"

    S_MISSSOURCE="missed!!"

    S_PRESS_ENTER_QUIT="(Press Enter to exit ...)"

    S_EULA="This package is copyright by Ministry of Education, R.O.C. (Taiwan).\nYou must read and agree our EULA in README file first."

    S_REVDATE="Release Date： $REVDATE"
    S_VERSION="Tables Version： $VERSION"

    S_INFO="This script will install tables and icons of MOE_HKIM in your SCIM engine.\n(It may require the password of current user)"
    S_DESTPATH="Tables path: "
    S_ICONPATH="Icons poth: "

    S_CONFIRMINSTALL="Continue? "
    S_ABORT="Abort!"

    S_NOMODULE="'$impath' Path not found!\nThat might be no SCIM engine installed in your system..."
    S_NOTDEFAULT="The SCIM engine is not your default input method, Cotinue anyway?"

    S_NEEDROOT="Current user account is not enough to access '/usr' !\nTry to log in as root first..."

    S_CANNOTREMOVE="Can't remove former tables of MOE_HKIM! Installation cancelled!"

    S_FINISH="Finish!\nPlease terminate the SCIM engine or reboot your system."
}

if echo $LANG | grep -i utf >/dev/null; then
    UseUTF8
else
    UseEng
fi

#################################################

YesNo() {
    msg="$1"
    default="$2"

    while : ; do
        if [ $default = 1 ]; then
            printf "$msg (y/[N]): "
        else
            printf "$msg ([Y]/n): "
        fi

        read answer

        if [ "$answer" ]; then
            case "$answer" in
                "y" | "Y" | "yes" | "Yes")
                    return 0
                           ;;
                "n" | "N" | "no" | "No")
                    return 1
                           ;;
                    *)
                    printf "$S_PRESS_Y_OR_N\n\n"
                    continue
                           ;;
            esac
        else
            return $default
        fi
    done
}

copyfile() {
    if [ -f "$curpath/$2" ]; then
        printf "$S_COPY $2 ... "
        sudo cp "$curpath/$2" $1

        if [ -f $1/$2 ]; then
            echo "$S_DONE"
        else
            echo "$S_FAILED"
        fi
    else
        printf "$2 $S_MISSSOURCE\n"
    fi
}

checkexist() {
    for fname in $2; do
        if [ -f $1/$fname ]; then
            exist=`expr $exist + 1`
        fi
    done
}

checktabs() {
    checkexist $destpath 'hkim_word_1-0.bin'
    checkexist $destpath 'hkim_word_1-1.bin'
    checkexist $destpath 'hkim_word_2-0.bin'
    checkexist $destpath 'hkim_word_2-1.bin'
    checkexist $destpath 'hkim_word_3-0.bin'
    checkexist $destpath 'hkim_word_3-1.bin'
    checkexist $destpath 'hkim_word_4-0.bin'
    checkexist $destpath 'hkim_word_4-1.bin'
    checkexist $destpath 'hkim_word_5-0.bin'
    checkexist $destpath 'hkim_word_5-1.bin'
    checkexist $destpath 'hkim_word_6-0.bin'
    checkexist $destpath 'hkim_word_6-1.bin'
}

checkicons() {
    checkexist $iconpath 'hkim.png'
}

terminal() {
    printf "$S_PRESS_ENTER_QUIT"
    read quit
    exit
}

#################################################

printf "$S_EULA\n\n"

printf "$S_REVDATE\n"
printf "$S_VERSION\n\n"

printf "===================================================\n\n"

printf "$S_INFO\n\n"
printf "$S_DESTPATH: $destpath\n$S_ICONPATH: $iconpath\n\n"

if ! YesNo "$S_CONFIRMINSTALL" 1; then
    printf "\n$S_ABORT\n"
    terminal
fi

echo ''

if [ ! -d $impath ]; then
    printf "$S_NOMODULE\n"
    terminal
fi

if ! `echo $XMODIFIERS | grep -i "scim" > /dev/null`; then
    if YesNo "$S_NOTDEFAULT" 1; then
        echo ''
    else
        printf "\n$S_ABORT\n"
        terminal
    fi
fi

if ! `sudo -l | grep -i "(ALL)" > /dev/null`; then
    printf "\n$S_NEEDROOT\n"
    terminal
fi

echo ''

if [ ! -d $destpath ]; then
    sudo mkdir -p -v $destpath
fi

if [ ! -d $iconpath ]; then
    sudo mkdir  -p -v $iconpath
fi

exist=0
checktabs
if [ $exist -gt 0 ]; then
    sudo rm $destpath/hkim_word_*.bin
fi

exist=0
checkicons
if [ $exist -gt 0 ]; then
    sudo rm $iconpath/hkim.png
fi

exist=0
checktabs
checkicons

if [ $exist -gt 0 ]; then
    printf "$S_CANNOTREMOVE\n"
    sudo -K
    terminal
fi

copyfile $destpath 'hkim_word_1-0.bin'
copyfile $destpath 'hkim_word_1-1.bin'
copyfile $destpath 'hkim_word_2-0.bin'
copyfile $destpath 'hkim_word_2-1.bin'
copyfile $destpath 'hkim_word_3-0.bin'
copyfile $destpath 'hkim_word_3-1.bin'
copyfile $destpath 'hkim_word_4-0.bin'
copyfile $destpath 'hkim_word_4-1.bin'
copyfile $destpath 'hkim_word_5-0.bin'
copyfile $destpath 'hkim_word_5-1.bin'
copyfile $destpath 'hkim_word_6-0.bin'
copyfile $destpath 'hkim_word_6-1.bin'

copyfile $iconpath 'hkim.png'

printf "\n$S_FINISH\n"
sudo -K
terminal
