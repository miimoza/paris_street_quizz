if [ $# -lt 1 ]; then
    echo "You have to select the gamemode!"
    echo ""
    echo "Gamemode List:"
    echo "  1 : Guess the district"
    echo "  2 : Guess the district with google maps correction"
    echo "  3 : Guess the district with google maps correction (One Window Mode)"
    echo "  4 : Which street it is ?"
    echo "  5 : Which street it is ? (One Window Mode)"
    echo "  6 : Which street it is, this one or this one ?"
    echo "  7 : Which street it is, this one or this one ? (One Window Mode)"
    echo ""
    echo "usage: ./psq.sh <gamemode> <minimum street length> <specific district>"

    exit
fi

if [ $1 -eq 1 ]; then
    ./scripts/quizz_rue_arr_witoutcorrection.sh
elif [ $1 = 2 ]; then
    ./scripts/quizz_rue_arr.sh
elif [ $1 = 3 ]; then
    ./scripts/quizz_rue_arr_onewindow.sh
elif [ $1 = 4 ]; then
    ./scripts/quizz_map_street.sh
elif [ $1 = 5 ]; then
    ./scripts/quizz_map_street_onewindow.sh
elif [ $1 = 6 ]; then
    ./scripts/quizz_map_street_easy.sh
elif [ $1 = 7 ]; then
    ./scripts/quizz_map_street_easy_onewindow.sh
else
    echo "You have to select the gamemode!"
    echo ""
    echo "Gamemode List:"
    echo "  1 : Guess the district"
    echo "  2 : Guess the district with google maps correction"
    echo "  3 : Guess the district with google maps correction (One Window Mode)"
    echo "  4 : Which street it is ?"
    echo "  5 : Which street it is ? (One Window Mode)"
    echo "  6 : Which street it is, this one or this one ?"
    echo "  7 : Which street it is, this one or this one ? (One Window Mode)"
    echo ""
    echo "usage: ./psq.sh <gamemode> <minimum street length> <specific district>"

    exit
fi
