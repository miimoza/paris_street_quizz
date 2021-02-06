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
        coord_info=$(./coord_info.sh $lat $lon)
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

        rue_length_average=$(echo $rue_length | cut -d'.' -f 1)


        rue=$(echo $rue | tr -d '"')
        ./showstreet.py "$rue"
        i3-msg workspace $current_ws > /dev/null

        printf "[$i] "

        newstreet_postcode=0
        newstreet_rue=0
        while [ $newstreet_postcode != $postcode ]; do
            r=$(( $RANDOM % $lenght ))
            newstreet_rue=$(echo $set | jq .l_longmin | tail -n $r | head -n 1)
            newstreet_rue_length=$(echo $set | jq .length | tail -n $r | head -n 1)
            newstreet_lat=$(echo $set | jq .geom_x_y[0] | tail -n $r | head -n 1)
            newstreet_lon=$(echo $set | jq .geom_x_y[1] | tail -n $r | head -n 1)
            newstreet_coord_info=$(./coord_info.sh $newstreet_lat $newstreet_lon)
            newstreet_rue_info=$(echo $newstreet_coord_info | jq .street)
            newstreet_postcode=$(echo $newstreet_coord_info | jq .postcode)

            if ! [[ $newstreet_postcode = \"75* ]]; then
              continue
            fi
        done

        if [ $((RANDOM % 2)) = 0 ]; then
            printf "(1) : $rue | (2) : $newstreet_rue ? "
            read rue_res
            if [[ $rue_res = 1 ]]; then
              success=$((success + 1))
            else
              echo "ECHEC --> $rue ($postcode)"
            fi
        else
            printf "(1) : $newstreet_rue | (2) : $rue ? "
            read rue_res
            if [[ $rue_res = 2 ]]; then
              success=$((success + 1))
            else
              echo "ECHEC --> $rue ($postcode)"
            fi
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
