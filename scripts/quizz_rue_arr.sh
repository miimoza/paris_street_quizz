#!/bin/sh
current_ws=$(i3-msg -t get_workspaces | jq ".[] | select(.focused!=false) | .name")

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
  min_length=500
fi

path="data/voie.geojson"
set=$(jq ".features[].properties | select(.length>$min_length)" $path)
lenght=$(echo $set | jq .length | wc -l)

echo "Welcome to Paris Street Quizz (area: 750$unique_arr, min length: ${min_length}m ->$lenght streets)"

echo ""
echo "Hit enter to play ..."
read

while [ 1 ]; do
    clear

    success=0

    i=1
    while [ $i -le 10 ]; do
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
        #echo "=================($i)==================="


        rue_length_average=$(echo $rue_length | cut -d'.' -f 1)
        printf "[$i] $rue | arrondissement (${rue_length_average}m): "

        read arr

        if [[ $arr -lt 10 ]]; then
            arr="0$arr"
        fi

        postcode_res="\"750$arr\""

        if [ $postcode_res == $postcode ]; then
          #echo "******* REUSSI *********"
          success=$((success + 1))
        else
          #printf "XXXXXXXXXX ECHEC XXXXXXXXX $postcode_res != $postcode .."
          echo "ECHEC --> $postcode"
          firefox "https://www.google.com/maps/@$lat,$lon,300m/data=!3m1!1e3?authuser=1"
          i3-msg workspace $current_ws > /dev/null
          #break
        fi

        #echo "(rue: $rue_info | postcode: $postcode | rue_length: $rue_length)"

        ((i++))
    done

    #echo "*****************************"
    echo "SCORE: $success/10"
    #echo "*****************************"

    echo ""
    echo "Hit enter for a new Game..."
    read
done
