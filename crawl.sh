#------------------------------------------------------
# Description : Affiche les hrefs internes et externes d'un site
# Auteur  : troger
# Date : 16/01/014
# Version : 0.1
#------------------------------------------------------

#!/bin/sh


#Passage en argument de l'url
if [ $# -ne 1 ]
then
echo Usage: $0 host
exit 1
fi

host=$1


# Fonction inArray
# $1 array tableau
# $2 string valeur a chercher
inArray() {
    local haystack=${1}[@]
    local needle=${2}
    for i in ${!haystack}; do
        if [[ ${i} == ${needle} ]]; then
            return 0
        fi
    done
    return 1
}


# Fronction crawl
# $1 string url
function crawl ()
{
    echo "crawl : "$1
    INTERNALSLINKS[${#INTERNALSLINKS[@]}]=$host$link
    links=`wget --quiet -O - $1 | grep -o '<a href=['"'"'"][^"'"'"']*['"'"'"]' | sed -e 's/^<a href=["'"'"']//' -e 's/["'"'"']$//'`

    for link in $links
    do
        echo "$link" | grep -q "^http"
        if grep -q "^http" <<< "$link" ; then
            inArray EXTERNALSLINKS $link && echo "duplicate url "$link || EXTERNALSLINKS[${#EXTERNALSLINKS[@]}]=$link
        else
            inArray INTERNALSLINKS $host$link && echo "duplicate url "$1$link || crawl $host$link 
        fi
    done;
}


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

