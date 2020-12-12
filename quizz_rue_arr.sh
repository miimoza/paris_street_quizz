#!/bin/sh

if [ $# -gt 0 ]; then
  min_length=$1
else
  min_length=1000
fi

path="data/voie.geojson"
set=$(jq ".features[].properties | select(.length>$min_length)" $path)
lenght=$(echo $set | jq .length | wc -l)
echo "set_length:$lenght"

success=0

for i in $(seq 0 10); do
    echo "====================================="
    lenght=$(echo $set | jq .length | wc -l)
    #echo $lenght

    r=$(( $RANDOM % $lenght ))
    #echo "random : $r"

    rue=$(echo $set | jq .l_longmin | tail -n $r | head -n 1)


    rue_length=$(echo $set | jq .length | tail -n $r | head -n 1)


    lat=$(echo $set | jq .geom_x_y[0] | tail -n $r | head -n 1)
    lon=$(echo $set | jq .geom_x_y[1] | tail -n $r | head -n 1)

    #echo "lat:$lat lon:$lon"
    coord_info=$(./coord_info.sh $lat $lon)
    rue_info=$(echo $coord_info | jq .street)
    postcode=$(echo $coord_info | jq .postcode)

    #echo $set | jq .length

    printf "$rue | arrondissement: "
    read arr

    if [[ $arr -lt 10 ]]; then
        arr="0$arr"
    fi

    postcode_res="\"750$arr\""

    if [ $postcode_res == $postcode ]; then
      printf "******* REUSSI *********"
      success=$((success + 1))
    else
      printf "XXXXXXXXXX ECHEC XXXXXXXXX $postcode_res != $postcode .."
      firefox "https://www.google.com/maps/@$lat,$lon,300m/data=!3m1!1e3?authuser=1"
    fi

    echo "(rue: $rue_info | postcode: $postcode | rue_length: $rue_length)"
done

echo "*****************************"
echo "score: $success/10"
echo "*****************************"
