#!/bin/bash
# lightsOn.sh

# Original version by iye.cba at gmail com
# url: https://github.com/iye/lightsOn
#
# Compilation version by Yegor Bayev
# url: https://github.com/kodx/lightsOn
#
# Contributors:
# Dylan Smith (https://github.com/dyskette/lightsOn)
# Andrew West (https://github.com/namtabmai/lightsOn)
#
# This script is licensed under GNU GPL version 2.0 or above

# Description: Bash script that prevents the screensaver and display power
# management (DPMS) to be activated when you are watching Flash or HTML5 Videos.
#
# It can detect mpv, mplayer, minitube, and VLC when they are fullscreen too.
# Also, screensaver can be prevented when certain specified programs are running.
# Optionally delay the screensaver when specific outputs are connected.

# HOW TO USE: Start the script with the number of seconds you want the checks
# for fullscreen to be done. Example:
#
# "./lightsOn.sh 120 &" will Check every 120 seconds if any of the supported
# applications are fullscreen and delay screensaver and Power Management if so.

# You want the number of seconds to be ~10 seconds less than the time it takes
# your screensaver or Power Management to activate. If you don't pass an
# argument, the checks are done every X seconds. Where X is calculated based on
# your system sleep time, with a minimum of $default_sleep_delay.

# An optional array variable exists here to add the names of programs that will
# delay the screensaver if they're running. This can be useful if you want to
# maintain a view of the program from a distance, like a music playlist.

# If you use this feature, make sure you use the name of the binary of the
# program (which may exist, for instance, in /usr/bin).

# VERSION=v0.1

# DEBUG=0 for no output
# DEBUG=1 for sleep prints
# DEBUG=2 for everything
DEBUG=0

# this is actually the minimum allowed dynamic delay.
# Also the default (if everything else fails)
default_sleep_delay=50

# Set this variable to 0 to disable checking for individual programs below,
# but instead trigger on any active fullscreen.
app_checks=1

# Modify these variables if you want this script to detect if MPV, Mplayer,
# VLC, Minitube, Totem or a web browser Flash/HTML5 Video.
mplayer_detection=0
mpv_detection=0
vlc_detection=0
totem_detection=0
firefox_flash_detection=1
firefox_html5_detection=1
chromium_flash_detection=1
chromium_html5_detection=1
chromium_pepper_flash_detection=1
chrome_pepper_flash_detection=0
chrome_html5_detection=0
opera_flash_detection=0
opera_html5_detection=0
yandexBrowser_html5_flash_detection=0
epiphany_html5_detection=0
webkit_flash_detection=1
minitube_detection=0

# Names of programs which, when running, you wish to delay the screensaver.
# For example ('ardour2' 'gmpc').
delay_progs=('steam')

# Display outputs to check, display screensaver when they are connected.
# Run xrandr to show current monitor config.
output_detection_control=0
output_detection=('VGA-0')

# DPMS settings in seconds, 600 seconds = 10 minutes.
# If you don't want to change DMPS settings, modify DPMS_Control to 0.
DPMS_Control=0
DPMS_StandbyTime=600
DPMS_SuspendTime=600
DPMS_OffTime=600

# X11 Screen Saver Extension settings in seconds, 600 seconds = 10 minutes.
# If you don't want to change these settings, modify X11ScreenSaver_Control to 0.
X11ScreenSaver_Control=0
X11ScreenSaver_Timeout=600

# YOU SHOULD NOT NEED TO MODIFY ANYTHING BELOW THIS LINE
gsettings_present=$(if [ -x $(which gsettings) ]; then echo 1; else echo 0; fi)
xdg_screensaver_present=$(if [ -x $(which xdg-screensaver) ]; then echo 1; else echo 0; fi)
delay_this_loop=0

log() {
    if [ $DEBUG -eq 2 ]; then
        echo "["`date +%H:%M:%S`"] - " $@
    elif [ $DEBUG -eq 1 ]; then
        if [ "$(echo $@ | grep -c 'sleeping for')" == "1" ]; then
            echo "["`date +%H:%M:%S`"] - " $@
        fi
    fi
}

pid=`pgrep --exact "$(basename $0)"`
if [ $? -eq 0 -a "$pid" != "$$" ]
then
    log "$0 is already running" 2>&1
    exit 1
fi

# Setting DPMS.
if [ $DPMS_Control == 1 ]; then
    log "Setting DPMS to Standby: $DPMS_StandbyTime, Suspend: $DPMS_SuspendTime, Off: $DPMS_OffTime"
    xset dpms $DPMS_StandbyTime $DPMS_SuspendTime $DPMS_OffTime
fi

# Setting X11 Screensaver Extension.
X11ScreenSaver_RestartTimeout="on"
if [ $X11ScreenSaver_Control == 1 ]; then
    X11ScreenSaver_RestartTimeout=$X11ScreenSaver_Timeout
    log "Setting X11 Screensaver Extension to Timeout: $X11ScreenSaver_RestartTimeout"
    xset s $X11ScreenSaver_RestartTimeout
fi

# enumerate all the attached screens
displays=$(xvinfo | awk -F'#' '/^screen/ {print $2}' | xargs)

# Detect screensaver being used
if pgrep -x xscreensaver > /dev/null; then
    screensaver=xscreensaver
    log "xscreensaver detected"
elif pgrep -x kscreensaver > /dev/null; then
    screensaver=kscreensaver
    log "kscreensaver detected"
elif pgrep -x xautolock > /dev/null; then
    screensaver=xautolock
    log "xautolock detected"
elif pgrep -x gnome-screensav > /dev/null; then
    screensaver=gnome-screensaver
    log "gnome-screensaver detected"
elif pgrep -x mate-screensave > /dev/null; then
    screensaver=mate-screensaver
    log "mate-screensaver detected"
elif pgrep -x cinnamon-screen > /dev/null; then
    screensaver=cinnamon-screensaver
    log "cinnamon-screensaver detected"
else
    screensaver=None
    log "No screensaver detected"
fi

checkDelayProgs()
{
    log "checkDelayProgs()"
    for prog in "${delay_progs[@]}"; do
        if [ $(pgrep -lfc "$prog") -ge 1 ]; then
            log "checkDelayProgs(): Delaying the screensaver because a program on the delay list, \"$prog\", is running..."
            delayScreensaver
            break
        fi
    done
}

checkFullscreen()
{
    if [ $delay_this_loop == 1 ]; then
        log "checkFullscreen() omitted - already delayed this loop"
        return
    fi

    log "checkFullscreen()"
    # Loop through every display looking for a fullscreen window.
    for display in $displays
    do
        # Get id of active window and clean output
        #activ_win_id=$(DISPLAY=:${display} xprop -root _NET_CLIENT_LIST_STACKING | sed 's/.*\, //')
        # Previously used _NET_ACTIVE_WINDOW, but it didn't work with some flash
        # players (eg. Twitch.tv) in firefox. Using sed because id lengths can vary.

        activ_win_id=$(DISPLAY=:0.${display} xprop -root _NET_ACTIVE_WINDOW | awk '{ print $5 }')

        # Check if active window is in fullscreen or above state.
        if [[ -n $activ_win_id ]] && [[ "$activ_win_id" != "0x0" ]]; then
            isActivWinFullscreen=$(DISPLAY=:${display} xprop -id $activ_win_id | grep -c _NET_WM_STATE_FULLSCREEN)
            # Above state is used in some window managers instead of fullscreen.
            isActivWinAbove=$(DISPLAY=:${display} xprop -id $activ_win_id | grep -c _NET_WM_STATE_ABOVE)
            log "checkFullscreen(): Display: $display isFullScreen=$isActivWinFullscreen"
            log "checkFullscreen(): Display: $display isAbove=$isActivWinAbove"
            if [[ "$isActivWinFullscreen" -ge 1 || "$isActivWinAbove" -ge 1 ]]; then
                log "checkFullscreen(): Fullscreen detected"
                isAppRunning
                var=$?
                if [[ $var -eq 1 ]]; then
                    delayScreensaver
                    return
                fi
                log "checkFullscreen(): the fullscreen app is unknown or not set to trigger the delay"
            else
                log "checkFullscreen(): NO fullscreen detected"
            fi
            # enable DPMS if necessary.
            dpmsStatus=$(xset -q | grep -c 'DPMS is Enabled')
            if [ $dpmsStatus == 0 ]; then
                xset dpms
                log "checkFullscreen(): DPMS enabled"
            fi
            # Turn on X11 Screensaver if necessary.
            X11ScreensaverStatus=$(xset q | grep timeout | sed "s/cycle.*$//" | tr -cd [:digit:])
            if [ $X11ScreensaverStatus -eq 0 ]; then
                log "checkFullscreen(): X11 Screensaver Extension enabled"
                xset s $X11ScreenSaver_RestartTimeout
            fi
        fi
    done
}

# Check if active window is matched with user settings.
# TODO only window name in the variable activ_win_title, not whole line.
# Then change IFs to detect more specifically the apps "<vlc>" and if process name exist.

# This function covers the standard way to check apps in isAppRunning
runcheck()
{
    if [[ "$activ_win_title" = *$1* ]]; then
        if [ "$(pidof -s $1)" ]; then
            log "isAppRunning(): $1 fullscreen detected"
            return 1
        fi
    fi
}

isAppRunning()
{
    if [ $app_checks == 0 ]; then
        log "isAppRunning() deactivated - delaying because something is running in fullscreen"
        return 1
    fi

    log "isAppRunning()"
    # Get title of active window.
    activ_win_title=$(xprop -id $activ_win_id | grep "WM_CLASS(STRING)")

    # Check if user want to detect Flash fullscreen on Firefox.
    if [ $firefox_flash_detection == 1 ]; then
        if [[ "$activ_win_title" = *unknown* || "$activ_win_title" = *plugin-container* ]]; then
            # Check if plugin-container process is running.
            if [ "$(pidof -s plugin-container)" ]; then
                log "isAppRunning(): firefox flash fullscreen detected"
                return 1
            fi
        fi
    fi

    # Check if user want to detect HTML5 fullscreen on Firefox.
    if [ $firefox_html5_detection == 1 ]; then
        if [[ "$activ_win_title" = *Firefox* || "$activ_win_title" = *Iceweasel* ]]; then
            # Check if Firefox process is actually running.
            # firefox_process=$(pgrep -c "(firefox|/usr/bin/firefox|iceweasel|/usr/bin/iceweasel)")
            if [ "$(pidof -s firefox iceweasel)" ]; then
                log "isAppRunning(): firefox html5 fullscreen detected"
                return 1
            fi
        fi
    fi

    # Check if user want to detect Flash fullscreen on Chromium.
    if [ $chromium_flash_detection == 1 ]; then
        if [[ "$activ_win_title" = *exe* || "$activ_win_title" = *hromium* ]]; then
            # Check if Chromium Flash process is running.
            flash_process=$(pgrep -lfc ".*chromium.*flashp.*")
            if [[ $flash_process -ge 1 ]]; then
                log "isAppRunning(): chromium flash fullscreen detected"
                return 1
            fi
        fi
    fi

    # Check if user want to detect HTML5 fullscreen on Chromium.
    if [ $chromium_html5_detection == 1 ]; then
        if [[ "$activ_win_title" == *hromium* ]]; then
            # Check if Chromium process is running.
            if [[ $(pgrep -c "chromium") -ge 1 ]]; then
                log "isAppRunning(): chromium html5 fullscreen detected"
                return 1
            fi
        fi
    fi

    # Check if user want to detect HTML5 fullscreen on Yandex browser.
    if [ $yandexBrowser_html5_flash_detection == 1 ]; then
        if [[ "$activ_win_title" == *andex-browser* ]]; then
            # Check if Yandex browser process is running.
            if [[ $(pgrep -c "yandex_browser") -ge 1 ]]; then
                log "isAppRunning(): Yandex browser fullscreen detected"
                return 1
            fi
        fi
    fi

    # Check if user want to detect Flash fullscreen on Chromium.
    if [ $chromium_pepper_flash_detection == 1 ]; then
        if [[ "$activ_win_title" = *hromium* ]]; then
            # Check if Chromium pepper Flash process is running.
            chromium_process=$(pgrep -lfc "chromium(|-browser) --type=ppapi ")
            if [[ $chromium_process -ge 1 ]]; then
                log "isAppRunning(): chromium pepper flash fullscreen detected"
                return 1
            fi
        fi
    fi

    # Check if user want to detect Flash fullscreen on Chrome.
    if [ $chrome_pepper_flash_detection == 1 ]; then
        if [[ "$activ_win_title" = *oogle-chrome* ]]; then
            # Check if Chrome pepper Flash process is running.
            chrome_process=$(pgrep -lfc "(c|C)hrome --type=ppapi ")
            if [[ $chrome_process -ge 1 ]]; then
                log "isAppRunning(): chrome flash fullscreen detected"
                return 1
            fi
        fi
    fi

    # Check if user want to detect HTML5 fullscreen on Chrome.
    if [ $chrome_html5_detection == 1 ]; then
        if [[ "$activ_win_title" = *oogle-chrome* ]]; then
            # Check if Chrome process is running.
            # chrome_process=`pgrep -lfc "(c|C)hrome --type=gpu-process "
            chrome_process=$(pgrep -lfc "(c|C)hrome")
            if [[ $chrome_process -ge 1 ]]; then
                log "isAppRunning(): chrome html5 fullscreen detected"
                return 1
            fi
        fi
    fi

    # Check if user want to detect Flash fullscreen on Opera.
    if [ $opera_flash_detection == 1 ]; then
        if [[ "$activ_win_title" = *operapluginwrapper* ]]; then
            # Check if Opera flash process is running.
            flash_process=$(pgrep -lfc operapluginwrapper-native)
            if [[ $flash_process -ge 1 ]]; then
                log "isAppRunning(): opera flash fullscreen detected"
                return 1
            fi
        fi
    fi

    # Check if user want to detect Flash fullscreen on WebKit.
    if [ $webkit_flash_detection == 1 ]; then
        if [[ "$activ_win_title" = *WebKitPluginProcess* ]]; then
            # Check if WebKit Flash process is running.
            flash_process=$(pgrep -lfc ".*WebKitPluginProcess.*flashp.*")
            if [[ $flash_process -ge 1 ]]; then
                log "isAppRunning(): webkit flash fullscreen detected"
                return 1
            fi
        fi
    fi

    # Check if user want to detect MPlayer fullscreen.
    if [ $mplayer_detection == 1 ]; then
        if [[ "$activ_win_title" = *mplayer* || "$activ_win_title" = *MPlayer* ]]; then
            # Check if MPlayer is running.
            if [ "$(pidof -s mplayer)" ]; then
                log "isAppRunning(): mplayer fullscreen detected"
                return 1
            fi
        fi
    fi

    if [ $opera_html5_detection == 1 ]; then runcheck opera; if [ $? == 1 ]; then return 1; fi; fi
    if [ $epiphany_html5_detection == 1 ]; then runcheck epiphany; if [ $? == 1 ]; then return 1; fi; fi
    if [ $totem_detection == 1 ]; then runcheck totem; if [ $? == 1 ]; then return 1; fi; fi
    if [ $mpv_detection == 1 ]; then runcheck mpv; if [ $? == 1 ]; then return 1; fi; fi
    if [ $vlc_detection == 1 ]; then runcheck vlc; if [ $? == 1 ]; then return 1; fi; fi
    if [ $minitube_detection == 1 ]; then runcheck minitube; if [ $? == 1 ]; then return 1; fi; fi

    return 0
}

delayScreensaver()
{
    delay_this_loop=1
    # Reset inactivity time counter so screensaver is not started.
    if [ "$screensaver" == "xscreensaver" ]; then
        log "delayScreensaver(): delaying xscreensaver..."
        xscreensaver-command -deactivate > /dev/null
    elif [ "$screensaver" == "kscreensaver" ]; then
        log "delayScreensaver(): delaying kscreensaver..."
        qdbus org.freedesktop.ScreenSaver /ScreenSaver SimulateUserActivity > /dev/null
    elif [ "$screensaver" == "xautolock" ]; then
        log "delayScreensaver(): delaying xautolock..."
        xautolock -disable
        xautolock -enable
    elif [ "$screensaver" == "gnome-screensaver" ]; then
        log "delayScreensaver(): delaying gnome-screensaver..."
        dbus-send --session --dest=org.gnome.ScreenSaver --type=method_call /org/gnome/ScreenSaver org.gnome.ScreenSaver.SimulateUserActivity >/dev/null 2>&1
    elif [ "$screensaver" == "mate-screensaver" ]; then
        log "delayScreensaver(): delaying mate-screensaver..."
        dbus-send --session --dest=org.mate.ScreenSaver --type=method_call /org/mate/ScreenSaver org.mate.ScreenSaver.SimulateUserActivity >/dev/null 2>&1
    elif [ "$screensaver" == "cinnamon-screensaver" ]; then
        log "delayScreensaver(): delaying cinnamon-screensaver..."
        dbus-send --session --dest=org.cinnamon.ScreenSaver --type=method_call /org/cinnamon/ScreenSaver org.cinnamon.ScreenSaver.SimulateUserActivity >/dev/null 2>&1
    else
        if [ $xdg_screensaver_present == 1 ]; then
            log "delayScreensaver(): trying to delay with xdg-screensaver..."
            xdg-screensaver reset
        fi
    fi

    # Check if DPMS is on. If it is, deactivate. If it is not, do nothing.
    dpmsStatus=$(xset -q | grep -c 'DPMS is Enabled')
    if [ $dpmsStatus == 1 ]; then
        xset -dpms
        log "delayScreennsaver(): DPMS disabled"
    fi

    # Turn off X11 Screensaver if necessary.
    X11ScreensaverStatus=$(xset q | grep timeout | sed "s/cycle.*$//" | tr -cd [:digit:])
    if [ $X11ScreensaverStatus -ge 1 ]; then
        log "delayScreensaver(): X11 Screensaver Extension disabled"
        xset s off
    fi

    # Reset gnome session idle timer.
    if [[ $gsettings_present == 1 && $(gsettings get org.gnome.desktop.session idle-delay 2>/dev/null) ]]; then
        sessionIdleDelay=$(gsettings get org.gnome.desktop.session idle-delay 2>/dev/null | sed "s/^.* //")
        if [[ $sessionIdleDelay -ge 1 ]]; then
            log "delayScreensaver(): resetting gnome session..."
            gsettings set org.gnome.desktop.session idle-delay 0 2>/dev/null
            gsettings set org.gnome.desktop.session idle-delay $sessionIdleDelay 2>/dev/null
        fi
    fi

    # Reset mate session idle timer.
    if [[ $gsettings_present == 1 && $(gsettings get org.mate.session idle-delay 2>/dev/null) ]]; then
        sessionIdleDelay=$(gsettings get org.mate.session idle-delay 2>/dev/null | sed "s/^.* //")
        if [[ $sessionIdleDelay -ge 1 ]]; then
            log "delayScreensaver(): resetting mate session..."
            gsettings set org.mate.session idle-delay 0 2>/dev/null
            gsettings set org.mate.session idle-delay $sessionIdleDelay 2>/dev/null
        fi
    fi
}

checkOutputs()
{
    if [ $output_detection_control == 0 ]; then return; fi
    if [ $delay_this_loop == 1 ]; then
        log "checkOutputs() omitted - already delayed this loop"
        return
    fi

    log "checkOutputs()"
    declare -A connected_outputs
    while read line
    do
        declare output
        IFS="=" read -a info <<< "$line"
        if [[ "${info[0]}" = "output" ]]; then
            output=${info[1]}
        elif [[ "${info[0]}" = "connected" && "${info[1]}" = "connected" ]]; then
            connected_outputs["${output}"]="connected"
        fi
    done < <(xrandr | sed -rn "s/^([^ ]+)[ ]+((dis)?connected)[ ]+(primary)?[ ]*([0-9]+x[0-9]+\+[0-9]+\+[0-9]+)?[ ]*.+$/output=\1\nconnected=\2\nignore=\3\nprimary=\4\nresolution=\5/p")

    for output in $output_detection
    do
        if [[ ${connected_outputs["$output"]} = "connected" ]]; then
            log "checkOutputs(): Delaying because of output"
            delayScreensaver
            return
        fi
    done
}

_sleep()
{
    delay_this_loop=0
    if [ $dynamicDelay -eq 0 ]; then
        log "sleeping for $delay"
        log "--------------- loop done! ---------------"
        sleep $delay
    else
        if [ -f /sys/class/power_supply/AC/online ]; then
            if [ $gsettings_present == 1 ]; then
                if [ "$(cat /sys/class/power_supply/AC/online)" == "1" ]; then
                    system_sleep_delay=$(gsettings get org.gnome.settings-daemon.plugins.power sleep-display-ac 2>/dev/null)
                else
                    system_sleep_delay=$(gsettings get org.gnome.settings-daemon.plugins.power sleep-display-battery 2>/dev/null)
                fi
            fi
        fi
        if [ "$(echo $system_sleep_delay | egrep -c "^[0-9]+$")" == "1" ]; then
            if [ $system_sleep_delay -le $(($default_sleep_delay+5)) ]; then
                sleep_delay=$default_sleep_delay
            else
                sleep_delay=$(($system_sleep_delay-5))
            fi
        else
            sleep_delay=$default_sleep_delay
        fi
        log "sleeping for $sleep_delay (system idle timeout is $system_sleep_delay)"
        log "--------------- loop done! ---------------"
        sleep $sleep_delay
    fi
}

delay=$1
dynamicDelay=0

# If argument empty, use dynamic delay.
if [ -z "$1" ]; then
    dynamicDelay=1
    log "No delay specified, dynamicDelay=1"
fi

# If argument is not integer quit.
if [[ $1 = *[^0-9]* ]]; then
    echo "The Argument \"$1\" is not valid, not an integer"
    echo "Please use the time in seconds you want the checks to repeat."
    echo "You want it to be ~10 seconds less than the time it takes your screensaver or DPMS to activate"
    exit 1
fi

while true
do
    checkDelayProgs
    checkOutputs
    checkFullscreen
    _sleep $delay
done

exit 0
