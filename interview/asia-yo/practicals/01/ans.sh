cat words.txt \
| tr 'A-Z' 'a-z' \
| tr -s ' ' '\n' \
| tr -dc '[:alpha:]\n' \
| sort \
| uniq -c \
| sort \
| tail -n 1 \
| sed 's/^ *//'

