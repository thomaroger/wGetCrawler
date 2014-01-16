#------------------------------------------------------
# Description : Affiche les connexions locales d'une personne
# Auteur  : troger
# Date : 16/01/014
# Version : 1.0
#------------------------------------------------------

#!/bin/sh

# Variable globale
#EXTERNALSLINKS=
#INTERNALSLINKS=

# Fronction crawl

function crawl ()
{
    echo "crawl : "$1

    links=`wget --quiet -O - $1 | grep -o '<a href=['"'"'"][^"'"'"']*['"'"'"]' | sed -e 's/^<a href=["'"'"']//' -e 's/["'"'"']$//'`

    for link in $links
    do
        echo "$link" | grep -q "^http"
        if grep -q "^http" <<< "$link" ; then
            EXTERNALSLINKS[${#INTERNALSLINKS[@]}]=$link
        else
            INTERNALSLINKS[${#INTERNALSLINKS[@]}]=$1$link
        fi
#        echo $link
    done;

    
}


#Passage en argument de l'url
if [ $# -ne 1 ]
then
echo Usage: $0 host
exit 1
fi

echo "HOST : "$1

crawl $1

echo "EXTERNALSLINKS"
for link in "${EXTERNALSLINKS[@]}"
do 
    echo $link
done

echo "INTERNALSLINKS"
for link in "${INTERNALSLINKS[@]}"
do 
    echo $link
done

