return-limits(){
     for process in $@; do
          process_pids=$(ps -C $process -o pid --no-headers | grep -oP "[[:digit:]]*")
          if [ -z $process_pids ]; then
             echo "[no $process running]"
          else
             for pid in $process_pids; do
                   echo "[$process #$pid -- limits]"
                   cat /proc/$pid/limits
             done
          fi
     done
}
