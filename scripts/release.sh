#!/bin/bash

if [[ $(uname) == 'Darwin' ]]
then
    SOURCE_DIR=$(realpath "$(dirname "$(realpath "$0")")"/..)
else
    SOURCE_DIR=$(readlink -f "$(dirname "$(realpath "$0")")"/..)
fi

cd "${SOURCE_DIR}" || exit

if [ $# -ne 2 ] ; then
    echo "usage: $0 x86|aarch64 debug|release"
    exit 1
fi

arch=$1
type=$2
if [ "${arch}" == "x86" ]; then
    install_dir=target/install
fi
if [ "${arch}" == "aarch64" ]; then
    install_dir=target/aarch64_install
fi

# 0) setup
mkdir -p                                   ${install_dir}/bin/
mkdir -p                                   ${install_dir}/config/


# 1) binary
for binary in \
        consensus \
        controller \
        executor \
        crypto \
        network \
        storage \
        ; do
    if [ "${arch}" == "x86" ]; then
        cp -rf "target/${type}/${binary}" ${install_dir}/bin/
    fi
    if [ "${arch}" == "aarch64" ]; then
        cp -rf "target/aarch64-unknown-linux-gnu/${type}/${binary}" ${install_dir}/bin/
    fi
done

rm -rf ${install_dir}/config/*
# 2) config
cp -rf tmp/*                    ${install_dir}/config/

# 3) scripts
cp -rf scripts                  ${install_dir}

exit 0
