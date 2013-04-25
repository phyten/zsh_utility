kill -9 `ps auxw | grep tashiro.pl | grep http | grep perl | awk '{print $2}' | perl -pe 's/\n/ /g'`
