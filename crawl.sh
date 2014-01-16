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
            return 1
        fi
    done
    return 0
}


# Fronction crawl
# $1 string url
function crawl ()
{
    INTERNALSLINKS[${#INTERNALSLINKS[@]}]=$1
    links=`wget --quiet -O - $1 | grep -o '<a href=['"'"'"][^"'"'"']*['"'"'"]' | sed -e 's/^<a href=["'"'"']//' -e 's/["'"'"']$//'`

    for link in $links
    do
        if grep -q "^http" <<< "$link" ; then
            if grep -q "^$host" <<< "$link" ; then
                inArray INTERNALSLINKS $link && crawl $link 
            else
                inArray EXTERNALSLINKS $link && EXTERNALSLINKS[${#EXTERNALSLINKS[@]}]=$link
            fi
        else
            inArray INTERNALSLINKS $host$link && crawl $host$link 
        fi
    done;
}

T="$(date +%s)"
crawl $1

echo "Externals links for $host : "
for link in "${EXTERNALSLINKS[@]}"
do 
    echo $link
done

echo "Internals links for $host :"
for link in "${INTERNALSLINKS[@]}"
do 
    echo $link
done

T="$(($(date +%s)-T))"
echo "executed time : ${T} seconds"
