D=`date +"%Y%m%d%H%M%S"`
B=`basename "$1"`
mv "$1" "archive/$D-$B"
