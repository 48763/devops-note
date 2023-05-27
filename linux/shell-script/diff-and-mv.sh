search() { 
    grep "$1" list

    if [ $? -eq 0 ]; then
        echo remove
    else
        echo not exist
    fi 
}

ls -1 video > list

while read -r line:
do

    search "$line"
done < list

