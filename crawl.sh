#------------------------------------------------------
# Description : Affiche les connexions locales d'une personne
# Auteur  : troger
# Date : 16/01/014
# Version : 1.0
#------------------------------------------------------

#!/bin/sh

# Fronction crawl

function crawl ()
{
    echo "crawl : "$1
    links=`wget --quiet -O - $1 | grep -o '<a href=['"'"'"][^"'"'"']*['"'"'"]' | sed -e 's/^<a href=["'"'"']//' -e 's/["'"'"']$//'`

    for link in $links
    do
        echo "$link" | grep -q "^http"
        if grep -q "^http" <<< "$link" ; then
            echo $link
        else
            echo $1$link
        fi
    done;    
}


#Passage en argument de l'url
if [ $# -ne 1 ]
then
echo Usage: $0 host
exit 1
fi

echo "HOST : "$1

arguments[0]=$1
arguments[1]=$1
arguments[2]=
arguments[3]= 

crawl $arguments



