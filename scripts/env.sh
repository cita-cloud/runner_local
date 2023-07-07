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
Usage: $(basename "$0") <command>
INFORMATIONAL COMMANDS
    help
        You are here.
OPERATION COMMANDS
    start <node_number>...
        Start the local node clusters by node_number.
        Start all the local node clusters if specified none.
    stop <node_number>...
        Stop the local node clusters by node_number.
        Stop all the local node clusters if specified none.
    clean <node_number>...
        Clean the runtime files of the local node clusters by node_number.
        Clean all the runtime files of the local node clusters if specified none.
EOF

}

start() {
    export PATH=$WS/../bin:$PATH

    local dir="$WS/../config/$(ls "$WS/../config" | grep "$1"$)" || return

    [ -f "$dir/pid_list" ] && echo "$(ls "$WS/../config" | grep "$1"$) is already running" && return

    cd "$dir"

    network run &
    pid_list[1]=$!
    consensus run &
    pid_list[2]=$!
    executor run &
    pid_list[3]=$!
    storage run &
    pid_list[4]=$!
    controller run &
    pid_list[5]=$!
    crypto run &
    pid_list[6]=$!

    echo -n "${pid_list[@]}" "" >> ./pid_list

    cd "$WS/.."

    echo "$(basename "$dir") started"
}

startall() {
    export PATH=$WS/../bin:$PATH

    for node in $(ls "$WS/../config")
    do
        local dir="$WS/../config/$node"

        [ -f "$dir/config.toml" ] || continue

        [ -f "$dir/pid_list" ] && echo "$node is already running" && continue

        cd "$dir"

        network run &
        pid_list[1]=$!
        consensus run &
        pid_list[2]=$!
        executor run &
        pid_list[3]=$!
        storage run &
        pid_list[4]=$!
        controller run &
        pid_list[5]=$!

        echo -n "${pid_list[@]}" "" >> ./pid_list

        cd "$WS/.."

        echo "$node started"
        
    done
}

stop() {
    local dir="$WS/../config/$(ls "$WS/../config" | grep "$1"$)" || return
    
    [ -f "$dir/pid_list" ] || return

    pid_list=$(cat "$dir/pid_list")
    for pid in ${pid_list[*]}; do
        kill "$pid"
    done

    rm "$dir/pid_list"

    echo "$(basename "$dir") stoped"
}

stopall() {
    for node in $(ls "$WS/../config")
    do
        local dir="$WS/../config/$node"
        [ -f "$dir/pid_list" ] || continue

        pid_list=$(cat "$dir/pid_list")
        for pid in ${pid_list[*]}; do
            kill "$pid"
        done

        rm "$dir/pid_list"

        echo "$node stoped"
        
    done
}


clean() {
    local dir="$WS/../config/$(ls "$WS/../config" | grep "$1"$)" || return
    
    [ -f "$dir/config.toml" ] || return

    if [ -f "$dir/pid_list" ]
    then
        pid_list=$(cat "$dir/pid_list")
        for pid in ${pid_list[*]}; do
            kill "$pid"
        done
        rm "$dir/pid_list"
    fi

    rm -rf "$dir"/data "$dir"/logs "$dir"/chain_data "$dir"/raft-data-dir "$dir"/overlord_wal

    echo "$(basename "$dir") cleaned"
}

cleanall() {
    for node in $(ls "$WS/../config")
    do
        local dir="$WS/../config/$node"
        [ -f "$dir/config.toml" ] || continue

        if [ -f "$dir/pid_list" ]
        then
            pid_list=$(cat "$dir/pid_list")
            for pid in ${pid_list[*]}; do
                kill "$pid"
            done
            rm "$dir/pid_list"
        fi

        rm -rf "$dir"/data "$dir"/logs "$dir"/chain_data "$dir"/raft-data-dir "$dir"/overlord_wal

        echo "$node cleaned"
        
    done
}

parse_command() {
    local command="$1"
    case "${command}" in
    help)
        help
        exit 0
        ;;

    start)
        if [ "$#" -gt 1 ]
        then
            for i in "$@"
            do
                expr $i + 1 >/dev/null 2>&1 || continue
                start "$i"
            done
        else
            startall
        fi
        exit 0
        ;;

    stop)
        if [ "$#" -gt 1 ]
        then
            for i in "$@"
            do
                expr $i + 1 >/dev/null 2>&1 || continue
                stop "$i"
            done
        else
            stopall
        fi
        exit 0
        ;;

    clean)
        if [ "$#" -gt 1 ]
        then
            for i in "$@"
            do
                expr $i + 1 >/dev/null 2>&1 || continue
                clean "$i"
            done
        else
            cleanall
        fi
        exit 0
        ;;

    *)
        help
        ;;

    esac
}

parse_command "$@"
