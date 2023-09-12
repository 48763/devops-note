#!/bin/bash
mem_free() {
    mem_num $(free -g | grep Mem)
}

mem_num() {
  echo $4
}

cpu_idle() {
    cpu_num $(top -n 1 -b | grep %Cpu | grep -o "[[:digit:].]*.id")
}

cpu_num() {
  echo ${1%.*}
}

date_echo() {
  echo $(date +"%Y-%m-%d %H:%M:%S"): ${1}
}

date_echo "Script Start"

restart=0

if [ $(mem_free) -lt 7 ]; then
    date_echo "Memory not enough $(mem_free)G"
    restart=1
fi

cnt=0
eva=0
while [ ${cnt} -lt 20 ];
do
    if [ $(cpu_idle) -lt 15 ]; then
        eva=$(( ${eva} + 1 ))
    fi

    if [ ${eva} -ge 3 ]; then
        date_echo "CPU not enough $(cpu_idle)%"
        restart=1
        break
    fi

    cnt=$(( ${cnt} + 1 ))
    sleep 3
done

if [ ${restart} -ne 0 ]; then
    date_echo "restart"
    sudo command -v command
fi

date_echo "Script End"
