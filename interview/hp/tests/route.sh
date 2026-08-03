#!/bin/bash
method="GET POST PATCH DELETE"
route="/ /file /file/ /file/etc /file/etc/ /file/etcd /file/etcd/ /file/etc/shadow /file/etc/shadow/"

for x in ${method}
do  
    echo "# method: ${x}" 

    for r in ${route}
    do
        echo "- route: ${r}" 
        case ${x} in
            
            GET|DELETE)
                echo "  output: $(curl -s -X ${x} localhost:8080${r})"
            ;;
            POST|PATCH)
                echo "  output: $(curl -s -X ${x} --data @test.txt localhost:8080${r})"
            ;;
        esac
    done
    
    echo 
done
