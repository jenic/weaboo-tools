canhas() {
    [ -z "$FILE" ] && FILE="$HOME/Documents/Data/current_weaboos"

    if [[ -z $@ ]]; then
        cat "$FILE"
        return 0
    fi

    if [[ "$@" == "all" ]]; then
        while read line; do
            eval `awk -F@@ \
                '{ if ($0 ~ /^[[:space:]]*#/) {next} else {print $2} }' \
                <<<"$line"` | \
                perl -ne \
                'if(/^(\d+).*?\[.*?\]\s?([A-z0-9!\s-]+)\s?-\s?(\d+)/){print "$1 $3,$2\n";}'
        done < "$FILE"
    fi

    for x in $@; do
        eval `grep -i $x "$FILE" | \
            awk -F@@ '{print $2}'`
    done
}

# This works for all XDCC lists powered by "XDCC Parser"
xdccq() {
    [ -z $2 ] && H='xdcc.horriblesubs.info' || H=$3

    # Relying on BOT global cuz lots of stuff is using it now
    B=`echo -n $BOT | urlencode`

    if [[ -z $DEBUG ]]; then
        ffget -q -O - http://$H/search.php"?nick=$B" | grep -i $1 | \
            awk -F, '{split($2,a,":"); print a[2], $4}'
    else
        ffget -O - http://$H/search.php"?nick=$B"
    fi

}

# HTML based
csbots() {
    [ -z $2 ] && H='tori.aoi-chan.com' || H=$2
    [ -z $3 ] && P='80' || P=$3

    if [[ -z $4 ]]; then
        lynx -dump "http://$H:$P" | grep -i "$1" | less
    else
        echo -e "s=$1\n---" | lynx -post_data \
            -dump "http://$H:$P" | less
    fi
}

weaboorename() {
    [ -z $1 ] && RX='s/.*(_|\s)(\d+)v?\d?\1.*/$2.mkv/' || RX="$1"

    rename -n "$RX" *.mkv && read && rename "$RX" *.mkv
    ls
}

watbot() {
    [ -z $1 ] && H='xdcc.horriblesubs.info' || H=$1

    ffget http://$H/ -q -O - | \
        grep p.nickPacks | \
        perl -nE "/.*'(.*?)'.*/; say \$1;"
}
