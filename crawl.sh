#------------------------------------------------------
# Description : Affiche les hrefs internes et externes d'un site
# Auteur  : troger
# Date : 16/01/014
# Version : 0.1
#------------------------------------------------------

#!/bin/sh

# Fonction inArray
# $1 tableau
# $2 valeur a chercher
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
declare -a vpsservers=("vps1" "vps2" "vps3" "vps4" "vps6");
#inArray vpsservers vps3 && echo "found" || echo "not found"
#ret=`inArray $vpsservers 'vps3'`
#echo $ret



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
            inArray INTERNALSLINKS $1$link && echo "duplicate url "$1$url || INTERNALSLINKS[${#INTERNALSLINKS[@]}]=$1$link 
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

