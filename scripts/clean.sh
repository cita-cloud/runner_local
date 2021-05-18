#!/bin/bash

# Commands Paths
if [[ $(uname) == 'Darwin' ]]; then
    WS=$(dirname "$(realpath "$0")")
else
    WS=$(dirname "$(readlink -f "$0")")
fi

pid_list=$(cat "$WS"/../pid_list)
for pid in ${pid_list[*]}; do
    kill "$pid"
done

rm -r "$WS"/../config/test-chain/node0/data "$WS"/../config/test-chain/node0/logs "$WS"/../config/test-chain/node0/chain_data
rm -r "$WS"/../config/test-chain/node1/data "$WS"/../config/test-chain/node1/logs "$WS"/../config/test-chain/node1/chain_data
rm "$WS"/../pid_list