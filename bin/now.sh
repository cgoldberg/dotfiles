#!/usr/bin/env bash
#
# now.sh - display current weather, calendar, and time
#
# this version was forked from original code posted on https://askubuntu.com/a/1020693
# by user @WinEunuuchs2Unix (2017-2019)
#
# requirements:
#  * `ncal` package for calendar (sudo apt install ncal)
#  * `toilet` package for clock font (sudo apt install toilet)

if [ ! -x "$(command -v cal)" ]; then
    echo "Command not found. Please install the 'ncal' package"
    exit 1
fi

if [ ! -x "$(command -v toilet)" ]; then
    echo "Command not found. Please install the 'toilet' package"
    exit 1
fi

# Replace Boston with your city name, GPS, etc. See: curl wttr.in/:help
LOCATION="Boston"

# setup for 92 character wide terminal
DateColumn=34  # default is 27 for 80 character line, 34 for 92 character line
TimeColumn=61  # default is 49 for   "   "   "   "    61 "   "   "   "

curl wttr.in/${LOCATION}?0 --silent --max-time 3 > /tmp/now-weather
readarray aWeather < /tmp/now-weather
rm -f /tmp/now-weather

if [[ "${aWeather[0]}" == "Weather report:"* ]]; then
    WeatherSuccess=true
    echo "${aWeather[@]}"
else
    WeatherSuccess=false
    echo "+============================+"
    echo "|                            |"
    echo "|                            |"
    echo "|     weather unavailable    |"
    echo "|                            |"
    echo "|                            |"
    echo "+============================+"
    echo
fi
echo

#-------- DATE --------------------------------------------------------------
# calendar, current month with today highlighted

tput sc  # save cursor position.

# move up 9 lines
i=0
while [ $((++i)) -lt 10 ]; do
    tput cuu1
done

if [[ "$WeatherSuccess" == true ]]; then
    # depending on length of your city name and country name you will:
    #   1. comment out next three lines of code. uncomment fourth code line.
    #   2. change subtraction value and set number of print spaces to match
    #      subtraction value. then place comment on fourth code line.
    Column=$((DateColumn - 10))
    tput cuf $Column  # Move x column number
    # Blank out ", country" with x spaces
    printf "          "
else
    tput cuf $DateColumn  # position to column 27 for date display
fi

cal > /tmp/terminal1
tr -cd '\11\12\15\40\60-\136\140-\176' < /tmp/terminal1 > /tmp/terminal

CalLineCnt=1
Today=$(date +"%e")

printf "\033[32m"  # color green

while IFS= read -r Cal
do
    printf "%s" "$Cal"
    if [[ $CalLineCnt -gt 2 ]]; then
        # see if today is on current line & invert background
        tput cub 22
        for (( j=0 ; j <= 18 ; j += 3 )); do
            Test=${Cal:$j:2}  # current day on calendar line
            if [[ "$Test" == "$Today" ]]; then
                printf "\033[7m"  # reverse: [7m
                printf "%s" "$Today"
                printf "\033[0m"  # normal: [0m
                printf "\033[32m"  # color green
                tput cuf 1
            else
                tput cuf 3
            fi
        done
    fi

    tput cud1  # down one line
    tput cuf $DateColumn  # move 27 columns right
    CalLineCnt=$((++CalLineCnt))
done < /tmp/terminal

printf "\033[00m" # color bright white
echo

tput rc  # restore saved cursor position.

#-------- TIME --------------------------------------------------------------

tput sc  # save cursor position.

# move up 8 lines
i=0
while [ $((++i)) -lt 9 ]; do
    tput cuu1
done

tput cuf $TimeColumn # move 49 columns right

echo " $(date +"%I:%M %P") " | toilet -f future --filter border > /tmp/terminal

while IFS= read -r Time; do
    printf "\033[01;92m"  # color intense green
    printf "%s" "$Time"
    tput cud1  # up one line
    tput cuf $TimeColumn  # move 49 columns right
done < /tmp/terminal

tput rc  # restore saved cursor position.

exit 0
