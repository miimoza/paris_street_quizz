if [ $# -ne 2 ]; then
	echo "usage: ./coord_info <longitude> <latitude>"
	exit
fi


lat=$1
lon=$2

curl -s "https://api-adresse.data.gouv.fr/reverse/?lon=$lon&lat=$lat" | jq -r ".features[0].properties"
