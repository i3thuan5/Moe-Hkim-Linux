#!/bin/sh

impath=/usr/share/scim
destpath=$impath/tables
iconpath=$impath/icons

UseUTF8() {
    S_PRESS_Y_OR_N="請輸入 y 或 n ..."

    S_DONE="完成"
    S_FAILED="失敗"

    S_PRESS_ENTER_QUIT="(請按 Enter 鍵結束...)"

    S_NONEEDUNINSTALL="您的系統中未發現需要移除的檔案！"

    S_INFO="本程序將為您移除 教育部客家語拼音輸入法 SCIM 表格檔及其相關圖示檔\n(移除過程中可能會要求您輸入目前使用者的登入密碼)"
    S_DESTPATH="表格安裝路徑"
    S_ICONPATH="圖示安裝路徑"

    S_CONFIRMUNINSTALL="您是否確定要移除？"
    S_ABORT="程序已中斷！"

    S_NEEDROOT="本移除程序必須存取 /usr 目錄，而您目前的使用者權限不足！\n請試著登入 root 帳戶再重新操作一次"

    S_REMOVETAB="移除表格檔"
    S_REMOVEICON="移除圖示檔"

    S_FINISH="移除結束！\n請重新啟動 SCIM 模組，或者重新登入系統"
}

UseEng() {
    S_PRESS_Y_OR_N="Press 'y' or 'n' ..."

    S_DONE="done"
    S_FAILED="failed"

    S_PRESS_ENTER_QUIT="(Press Enter to exit ...)"

    S_NONEEDUNINSTALL="There is no file need remove!"

    S_INFO="This script will uninstall tables and icons of MOE_HKIM in your SCIM engine.\n(It may require the password of current user)"
    S_DESTPATH="Tables path: "
    S_ICONPATH="Icons poth: "

    S_CONFIRMUNINSTALL="Continue? "
    S_ABORT="Abort!"

    S_NEEDROOT="Current user account is not enough to access '/usr' !\nTry to log in as root first..."

    S_REMOVETAB="Remove tables"
    S_REMOVEICON="Remove icons"

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

exist=0
checktabs
checkicons

if [ $exist -eq 0 ]; then
    printf "$S_NONEEDUNINSTALL\n"
    terminal
fi

printf "$S_INFO\n\n"
printf "$S_DESTPATH: $destpath\n$S_ICONPATH: $iconpath\n\n"

if ! YesNo "$S_CONFIRMUNINSTALL" 1; then
    printf "\n$S_ABORT\n"
    terminal
fi

echo ''

if ! `sudo -l | grep -i "(ALL)" > /dev/null`; then
    printf "\n$S_NEEDROOT\n"
    terminal
fi

echo ''

exist=0
checktabs

if [ $exist -gt 0 ]; then
    printf "$S_REMOVETAB ... "
    sudo rm $destpath/hkim_word_*.bin

    exist=0
    checktabs

    if [ $exist -gt 0 ]; then
        echo "$S_FAILED"
    else
        echo "$S_DONE"
    fi
fi

exist=0
checkicons

if [ $exist -gt 0 ]; then
    printf "$S_REMOVEICON ... "
    sudo rm $iconpath/hkim.png

    exist=0
    checkicons

    if [ $exist -gt 0 ]; then
        echo "$S_FAILED"
    else
        echo "$S_DONE"
    fi
fi

printf "\n$S_FINISH\n"
sudo -K
terminal
