#!/bin/bash

# Commands Paths
if [[ $(uname) == 'Darwin' ]]; then
    WS=$(dirname "$(realpath "$0")")
else
    WS=$(dirname "$(readlink -f "$0")")
fi

export PATH=$WS/../bin:$PATH

cd config/test-chain/node0

network run -p 50000 -k network-key &
pid_list[1]=$!
consensus run -p 50001 &
pid_list[2]=$!
executor run -p 50002 &
pid_list[3]=$!
storage run -p 50003 &
pid_list[4]=$!
controller run -p 50004 &
pid_list[5]=$!
kms run -p 50005 -k key_file &
pid_list[6]=$!

cd -
cd config/test-chain/node1

network run -p 60000 -k network-key &
pid_list[7]=$!
consensus run -p 60001 &
pid_list[8]=$!
executor run -p 60002 &
pid_list[9]=$!
storage run -p 60003 &
pid_list[10]=$!
controller run -p 60004 &
pid_list[11]=$!
kms run -p 60005 -k key_file &
pid_list[12]=$!

echo "${pid_list[@]}" > "$WS"/../pid_list
