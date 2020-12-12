

while read -r line; do
    count=$(echo $line | cut -d' ' -f1)
    typ_voie=$(echo $line | cut -d' ' -f2)
    lib_voie=$(echo $line | cut -d' ' -f3-)

    length=$(jq ".features[].properties | select(.c_desi == \"$typ_voie\") | select(.l_voie == \"$lib_voie\") |  select(.length>300) | .length" data/voie3.json)

    ratio=$(bc <<< "scale=2; $count / ($length / 1000)")

    echo "$ratio | $count | $typ_voie | $lib_voie | $length"
done < data/COMMERCES_DENSES
