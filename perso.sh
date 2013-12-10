#/bin/sh
if test $# -ne 1 
then
	echo "Nombre de paramètres incorrect"
	exit 1
fi

APP_upper=$(echo $1 | tr '[:lower:]' '[:upper:]')
APP_lower=$(echo $1 | tr '[:upper:]' '[:lower:]')

bin/newapp.sh -v -i=NET -o=$APP_upper

bin/replacestr.sh -v -i=net -o=$APP_lower -s $APP_upper/$APP_upper/rc-$APP_lower.tk $APP_upper/$APP_upper/$APP_lower.tk $APP_upper/$APP_upper/$APP_lower-???.tk

bin/replacestr.sh -v -i=NET -o=$APP_upper -s $APP_upper/$APP_upper/rc-$APP_lower.tk $APP_upper/$APP_upper/$APP_lower.tk $APP_upper/$APP_upper/$APP_lower-???.tk

path=$(pwd)

cd $APP_upper

make icon

make install

cd $path

exit 0
