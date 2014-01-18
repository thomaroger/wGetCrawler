#------------------------------------------------------
# Description : Affiche les hrefs internes et externes d'un site
# Auteur  : troger
# Date : 16/01/014
# Version : 0.1
#------------------------------------------------------

#!/bin/sh


#Passage en argument de l'url
debug=1

if [[ $# != 2 ]]; 
then
    if [[ $# != 1 ]];
    then
        echo Usage: $0 host [-v]
        exit 1
    else
        debug=0
    fi
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
    if [[ $debug == 1 ]]; 
    then
        echo $1
    fi
    internalslinks[${#internalslinks[@]}]=$1

    wget --quiet -O - $1 > ./data/wgetResult.tmp
    links=`cat ./data/wgetResult.tmp | grep -o '<a href=['"'"'"][^"'"'"']*['"'"'"]' | sed -e 's/^<a href=["'"'"']//' -e 's/["'"'"']$//'`
    title=`cat ./data/wgetResult.tmp | sed -n -e 's!.*<title>\(.*\)</title>.*!\1!p'`
    keywords=`cat ./data/wgetResult.tmp | grep -o '<meta name="keywords" content=".*".*/>' | sed  -e 's/.*<meta name="keywords" content="//' -e 's/" \/>.*//' -e 's/"\/>.*//'` 
    description=`cat ./data/wgetResult.tmp | grep -o '<meta name="description" content=".*".*/>' | sed  -e 's/.*<meta name="description" content="//' -e 's/" \/>.*//' -e 's/"\/>.*//'`
    h1=`cat ./data/wgetResult.tmp | grep -o '<h1>.*</h1>' | sed  -e 's/.*<h1>//' -e 's/<\/h1>.*/ | /'` 
    h2=`cat ./data/wgetResult.tmp | grep -o '<h2>.*</h2>' | sed  -e 's/.*<h2>//' -e 's/<\/h2>.*/ | /'`
    h3=`cat ./data/wgetResult.tmp | grep -o '<h3>.*</h3>' | sed  -e 's/.*<h3>//' -e 's/<\/h3>.*/ | /'`
    h4=`cat ./data/wgetResult.tmp | grep -o '<h4>.*</h4>' | sed  -e 's/.*<h4>//' -e 's/<\/h4>.*/ | /'`
    h5=`cat ./data/wgetResult.tmp | grep -o '<h5>.*</h5>' | sed  -e 's/.*<h5>//' -e 's/<\/h5>.*/ | /'`
    h6=`cat ./data/wgetResult.tmp | grep -o '<h6>.*</h6>' | sed  -e 's/.*<h6>//' -e 's/<\/h6>.*/ | /'` 
    as=`cat ./data/wgetResult.tmp | grep -o '<a href=".*".*</a>' | sed -e 's/<\/a>.*/ | /' -e 's/<a.*>//'`

    echo "URL : "$1 >> result.txt
    echo "TITRE : "$title >> result.txt
    echo "KEYWORDS : "$keywords >> result.txt
    echo "DESCRIPTION : "$description >> result.txt
    echo "H1 : "$h1 >> result.txt
    echo "H2 : "$h2 >> result.txt
    echo "H3 : "$h3 >> result.txt
    echo "H4 : "$h4 >> result.txt
    echo "H5 : "$h5 >> result.txt
    echo "H6 : "$h6 >> result.txt
    echo "TEXTE DE LIEN : "$as >> result.txt
    echo "" >> result.txt
    echo "" >> result.txt
    
    for link in $links
    do
        if grep -q "^http" <<< "$link" ; then
            if grep -q "^$host" <<< "$link" ; then
                inArray internalslinks $link && crawl $link 
            else
                inArray externalslinks $link && externalslinks[${#externalslinks[@]}]=$link
            fi
        else
            inArray internalslinks $host$link && crawl $host$link 
        fi
    done;
}

T="$(date +%s)"
rm -f result.txt
mkdir data
crawl $1

echo "Externals links for $host : "
for link in "${externalslinks[@]}"
do 
    echo $link
done

echo "Internals links for $host :"
for link in "${internalslinks[@]}"
do 
    echo $link
done


rm -rf data
T="$(($(date +%s)-T))"
echo "executed time : ${T} seconds"
