#!/bin/bash

# Commands Paths
if [[ $(uname) == 'Darwin' ]]; then
    WS=$(dirname "$(realpath "$0")")
else
    WS=$(dirname "$(readlink -f "$0")")
fi

# INFORMATIONAL COMMANDS
help() {
    cat <<EOF
Usage: $SCRIPT <command>
 INFORMATIONAL COMMANDS
    help
        You are here.
 OPERATION COMMANDS
    start <node_dir> <network_port>
        Start the local node clusters.
    stop
        Stop the local node clusters.
    clean
        Clean the runtime files of the local node clusters.
EOF

}

start() {
    export PATH=$WS/../bin:$PATH

    local dir=$2
    local port=$3

    cd "$dir"

    pwd

    network run -p "$port" -k network-key &
    pid_list[1]=$!
    consensus run -p $((port+1)) &
    pid_list[2]=$!
    executor run -p $((port+2)) &
    pid_list[3]=$!
    storage run -p $((port+3)) &
    pid_list[4]=$!
    controller run -p $((port+4)) &
    pid_list[5]=$!
    kms run -p $((port+5)) -k key_file &
    pid_list[6]=$!

    cd -

    echo -n "${pid_list[@]}" "" >> "$WS"/../pid_list
}

stop() {
    pid_list=$(cat "$WS"/../pid_list)
    for pid in ${pid_list[*]}; do
        kill "$pid"
    done

    rm "$WS"/../pid_list
}


clean() {
    if [ ! -f "$WS"/../pid_list ]; then
        stop
    fi

    local dir=$2

    rm -r "$dir"/data "$dir"/logs "$dir"/chain_data
}


parse_command() {
    local command="$1"
    case "${command}" in
    help)
        help
        exit 0
        ;;

    start)
        start "$@"
        exit 0
        ;;

    stop)
        stop
        ;;

    clean)
        clean "$@"
        ;;

    *)
        help
        ;;

    esac
}

parse_command "$@"
