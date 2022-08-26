#!/usr/bin/env sh
clear
echo 'Spotify Playlist Searcher'
oylt='ould you like to'
while [[ ! $number =~ ^[0-9]+$ ]]
do
    read -p "How many songs w$oylt enter? " number
if [[ $number =~ ^[0-9]+$ ]] ; then
    break
fi
    echo 'Please enter a number'
done
current=1
while [ $number -ne 0 ]
do
    read -p "Enter the name of song $current: " song
    arr[$current]='"'${song}'"'
    let "number--"
    let "current++"
done
read -p "W$oylt exclude playlists over 24 hours? " long
search="${arr[*]}"+'-"Spotify%20Playlist"'
search="${search//'" "'/"+"}"
search="${search//' '/%20}"
if [[ $long == *Y* ]] || [[ $long == *y* ]] || [[ $long == *Yes* ]] || [[ $long == *YES* ]] || [[ $long == *yes* ]];
then
    search+='+-"over%2024%20hr"'
fi
clear
agent='Mozilla/5.0 (X11; Linux x86_64; rv:105.0) Gecko/20100101 Firefox/105'
link='open.spotify.com'
curl -s 'https://www.google.com/search?hl=en&q=site%3A'${link}'/playlist+'${search}'' -A "${agent}" > tmp
read -a arr <<< $(cat tmp | grep -Eoi '"https:\/\/'${link}'\/playlist\/.{0,22}')
for each in "${arr[@]/?/}"
do
    let "number++"
    echo $number
    curl -s "$each" -A "${agent}" > tmp
    cat tmp | grep -Eoi 'og:ti.{0,60}' | sed '/:ti/,/meta/p'| cut -c 20- #-d"meta
done
rm tmp
while [[ ! $pnumber =~ ^[0-9]+$ ]]
do
    read -p "Which playlist w$oylt open? " pnumber
#if [[ $pnumber -gt $number ]] ; then
#    echo "The number you entered is higher than the amount of playlists available, which is $number" 
#fi
#	break
done
open -a spotify ${arr[pnumber-1]/?/}
exit
