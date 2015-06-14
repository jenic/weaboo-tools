canhas() {
    if [[ -z "$FILE" ]];
    then
        FILE="$HOME/Documents/Data/current_weaboos"
    fi

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
    if [[ -z $2 ]]; then
        #H='xdcc.utw.me'
        H='xdcc.horriblesubs.info'
    else
        H=$3
    fi
    # Relying on BOT global cuz lots of stuff is using it now
    B=`echo -n $BOT | urlencode`
    ffget -q -O - http://$H/search.php"?nick=$B" | grep -i $1 | \
        awk -F, '{split($2,a,":"); print a[2], $4}'
}

# HTML based
csbots() {
    if [[ -z $2 ]]; then
        H='tori.aoi-chan.com'
    else
        H=$2
    fi

    if [[ -z $3 ]]; then
        P='80'
    else
        P=$3
    fi

    if [[ -z $4 ]]; then
        lynx -dump "http://$H:$P" | grep -i "$1" | less
    else
        echo -e "s=$1\n---" | lynx -post_data \
            -dump "http://$H:$P" | less
    fi
}

weaboorename() {
    if [[ -z $1 ]]; then
        RX='s/.*(_|\s)(\d+)v?\d?\1.*/$2.mkv/'
    else
        RX="$1"
    fi

    rename -n "$RX" *.mkv && read && rename "$RX" *.mkv
    ls
}

watbot() {
    if [[ -z $1 ]]; then
        H='xdcc.horriblesubs.info'
    else
        H="$1"
    fi

    ffget http://$H/ -q -O - | \
        grep p.nickPacks | \
        perl -nE "/.*'(.*?)'.*/; say \$1;"
}
