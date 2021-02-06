#!/bin/sh

unique_arr=0

if [ $# -gt 0 ]; then
  min_length=$1
  if [ $# -gt 1 ]; then
    unique_arr=$2
    if [[ $unique_arr -lt 10 ]]; then
        unique_arr="0$unique_arr"
    fi
  fi
else
  min_length=1000
fi

path="data/voie.geojson"
set=$(jq ".features[].properties | select(.length>$min_length)" $path)
lenght=$(echo $set | jq .length | wc -l)
echo "set_length:$lenght"


success=0

i=1
while [ $i -le 100 ]; do
    lenght=$(echo $set | jq .length | wc -l)
    #echo $lenght

    r=$(( $RANDOM % $lenght ))
    #echo "random : $r"

    rue=$(echo $set | jq .l_longmin | tail -n $r | head -n 1)

    rue_length=$(echo $set | jq .length | tail -n $r | head -n 1)

    lat=$(echo $set | jq .geom_x_y[0] | tail -n $r | head -n 1)
    lon=$(echo $set | jq .geom_x_y[1] | tail -n $r | head -n 1)
    #echo "lat:$lat lon:$lon"
    coord_info=$(./scripts/coord_info.sh $lat $lon)
    rue_info=$(echo $coord_info | jq .street)
    postcode=$(echo $coord_info | jq .postcode)

    # check null or not in paris
    if ! [[ $postcode = \"75* ]]; then
      continue
    fi



    # CHECK UNIQUE ARR PARAMETER
    if [ $unique_arr -gt 0 ]; then
        postcode_unique="\"750$unique_arr\""
        if [ $postcode != $postcode_unique ]; then
          continue
        fi
    fi





    # INPUT
    echo "=================($i)==================="

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
      break
    fi

    echo "(rue: $rue_info | postcode: $postcode | rue_length: $rue_length)"

    ((i++))
done

echo "*****************************"
echo "score: $success"
echo "*****************************"
