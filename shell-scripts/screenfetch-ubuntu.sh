#!/usr/bin/env bash
#
#  screenfetch-ubuntu.sh - Bash script that displays Ubuntu ASCII art logo and system info.
#  Copyright (c) 2015 Corey Goldberg
#
#  This code is based on 'screenfetch': https://github.com/KittyKatt/screenFetch
#  Copyright (c) 2010-2014 Brett Bohnenkamper <kittykatt@kittykatt.us>
#
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>.


display=( distro host kernel uptime mem disk )

c0="\033[0m" # Reset Text
bold="\033[1m" # Bold Text
underline="\033[4m" # Underline Text

colorize () {
  printf "\033[38;5;$1m"
}

getColor() {
  tmp_color=${1,,}

  case "${tmp_color}" in
    'light grey')	color_ret='\033[0m\033[37m';;
    'light green')	color_ret='\033[0m\033[1;32m';;
    'orange')       color_ret="$(colorize '202')";;
    'yellow')		color_ret='\033[0m\033[1;33m';;
    'red')			color_ret='\033[0m\033[31m';;
  esac
  echo "${color_ret}"
}


# Distro detection
detectdistro () {
  distro=$(lsb_release -ds)
  asc_distro=$(lsb_release -is)
}

# Host detection
detecthost () {
  myHost=${HOSTNAME}
}

# Kernel detection
detectkernel () {
  kernel=$(uname -srm)
}


# Uptime detection
detectuptime () {
  uptime=$(</proc/uptime)
  uptime=${uptime//.*}
  secs=$((${uptime}%60))
  mins=$((${uptime}/60%60))
  hours=$((${uptime}/3600%24))
  days=$((${uptime}/86400))
  uptime="${mins}m"
  if [ "${hours}" -ne "0" ]; then
    uptime="${hours}h ${uptime}"
  fi
  if [ "${days}" -ne "0" ]; then
    uptime="${days}d ${uptime}"
  fi
}


# Disk Usage detection
detectdisk () {
  totaldisk=$(df -h --total 2>/dev/null | tail -1)
    disktotal=$(awk '{print $2}' <<< "${totaldisk}")
    diskused=$(awk '{print $3}' <<< "${totaldisk}")
    diskusedper=$(awk '{print $5}' <<< "${totaldisk}")
    diskusage="${diskused} / ${disktotal} (${diskusedper})"
    diskusage_verbose=$(sed 's/%/%%/' <<< $diskusage)
}


# Memory detection
detectmem () {
	human=1024
    mem_info=$(</proc/meminfo)
    mem_info=$(echo $(echo $(mem_info=${mem_info// /}; echo ${mem_info//kB/})))
    for m in $mem_info; do
        if [[ ${m//:*} = MemTotal ]]; then
            memtotal=${m//*:}
        fi

        if [[ ${m//:*} = MemFree ]]; then
            memfree=${m//*:}
        fi

        if [[ ${m//:*} = Buffers ]]; then
            membuffer=${m//*:}
        fi

        if [[ ${m//:*} = Cached ]]; then
            memcached=${m//*:}
        fi
    done
    usedmem="$(((($memtotal - $memfree) - $membuffer - $memcached) / $human))"
    totalmem="$(($memtotal / $human))"
	mem="${usedmem}MB / ${totalmem}MB"
}


asciiText () {
    c1=$(getColor 'orange')
    c2=$(getColor 'red')
    c3=$(getColor 'yellow')
    startline="0"
	fulloutput=("$c2                          ./+o+-       %s"
"$c1                  yyyyy- $c2-yyyyyy+     %s"
"$c1               $c1://+//////$c2-yyyyyyo     %s"
"$c3           .++ $c1.:/++++++/-$c2.+sss/\`     %s"
"$c3         .:++o:  $c1/++++++++/:--:/-     %s"
"$c3        o:+o+:++.$c1\`..\`\`\`.-/oo+++++/    %s"
"$c3       .:+o:+o/.$c1          \`+sssoo+/   %s"
"$c1  .++/+:$c3+oo+o:\`$c1             /sssooo.  %s"
"$c1 /+++//+:$c3\`oo+o$c1               /::--:.  %s"
"$c1 \+/+o+++$c3\`o++o$c2               ++////.  %s"
"$c1  .++.o+$c3++oo+:\`$c2             /dddhhh.  %s"
"$c3       .+.o+oo:.$c2          \`oddhhhh+   %s"
"$c3        \+.++o+o\`\`-\`\`$c2\`\`.:ohdhhhhh+    %s"
"$c3         \`:o+++ $c2\`ohhhhhhhhyo++os:     %s"
"$c3           .o:$c2\`.syhhhhhhh/$c3.oo++o\`     %s"
"$c2               /osyyyyyyo$c3++ooo+++/    %s"
"$c2                   \`\`\`\`\` $c3+oo+++o\:    %s"
"$c3                          \`oo++.      %s")


    for ((i=0; i<${#fulloutput[*]}; i++)); do
        printf "${fulloutput[i]}$c0\n" "${out_array}"
        if [[ "$i" -ge "$startline" ]]; then
            unset out_array[0]
            out_array=( "${out_array[@]}" )
        fi
    done

}

infoDisplay () {
    display_index=0
    labelcolor=$(getColor 'light green')
	textcolor=$(getColor 'light grey')
    if [[ "${display[@]}" =~ "host" ]]; then
        myinfo=$(echo -e "${labelcolor}Host:$textcolor $myHost");
        out_array=( "${out_array[@]}" "$myinfo" );
        ((display_index++));
    fi
    if [[ "${display[@]}" =~ "distro" ]]; then
        mydistro=$(echo -e "$labelcolor OS:$textcolor $distro $sysArch");
        out_array=( "${out_array[@]}" "$mydistro" )
        ((display_index++))
    fi
    if [[ "${display[@]}" =~ "kernel" ]]; then
        mykernel=$(echo -e "$labelcolor Kernel:$textcolor $kernel");
        out_array=( "${out_array[@]}" "$mykernel" );
        ((display_index++));
    fi
    if [[ "${display[@]}" =~ "uptime" ]]; then
        myuptime=$(echo -e "$labelcolor Uptime:$textcolor $uptime");
        out_array=( "${out_array[@]}" "$myuptime" );
        ((display_index++));
    fi
    if [[ "${display[@]}" =~ "disk" ]]; then
        mydisk=$(echo -e "$labelcolor Disk:$textcolor $diskusage");
        out_array=( "${out_array[@]}" "$mydisk" );
        ((display_index++));
    fi
    if [[ "${display[@]}" =~ "mem" ]]; then
        mymem=$(echo -e "$labelcolor RAM:$textcolor $mem");
        out_array=( "${out_array[@]}" "$mymem" );
        ((display_index++));
    fi

    asciiText
}

for i in "${display[@]}"; do
    detect${i} 2>/dev/null
done

echo
infoDisplay
echo

exit 0
