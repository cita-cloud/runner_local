# cloud-config

创建链的配置文件。

### 依赖

* rust: 1.54.0

### 安装

```
cargo install --path .
```

### 用法

```
$ cloud-config help
cloud-config 6.3.0

Yieazy

USAGE:
    cloud-config <SUBCOMMAND>

FLAGS:
    -h, --help       Print help information
    -V, --version    Print version information

SUBCOMMANDS:
    append    append config
    create    create config
    delete    delete config
    help      Print this message or the help of the given subcommand(s)
```

### 初始化链

```
$ config-config create -h
cloud-config-create 

create config

USAGE:
    cloud-config create [OPTIONS] --consensus <CONSENSUS>

FLAGS:
FLAGS:
    -h, --help       Print help information
        --use_num    use serial number instead of node address

OPTIONS:
        --chain-name <CHAIN_NAME>
            set chain name [default: test-chain]

        --config-dir <CONFIG_DIR>
            set config file directory, default means current directory

        --config-name <CONFIG_NAME>
            set config file name [default: config.toml]

        --consensus <CONSENSUS>
            Set consensus micro-service

        --controller <CONTROLLER>
            Set controller micro-service [default: controller]

        --executor <EXECUTOR>
            Set executor micro-service [default: executor_evm]

        --grpc-ports <GRPC_PORTS>
            grpc port list, input "p1,p2,p3,p4", use default grpc port count from 50000 + 1000 * i
            use default must set peer_count or p2p_ports [default: default]

        --kms <KMS>
            Set kms micro-service [default: kms_sm]

        --kms-password <KMS_PASSWORD>
            kms db password [default: 123456]

        --network <NETWORK>
            Set network micro-service [default: network_p2p]

        --p2p-ports <P2P_PORTS>
            p2p port list, input "ip1:port1,ip2:port2,ip3:port3,ip4:port4", use default port count
            from 127.0.0.1:40000 + 1 * i, use default must set peer_count or grpc_ports [default:
            default]

        --package-limit <PACKAGE_LIMIT>
            set one block contains tx limit, default 30000 [default: 30000]

        --peers-count <PEERS_COUNT>
            set initial node number, default "none" mean not use this must set grpc_ports or
            p2p_ports, if set peers_count, grpc_ports and p2p_ports, base on grpc_ports > p2p_ports
            > peers_count

        --storage <STORAGE>
            Set storage micro-service [default: storage_rocksdb]

        --version <VERSION>
            set version [default: 0]
```

#### 例子

```
$ cloud-config create --peers-count 4 --consensus consensus_raft --network network_p2p --config-dir tmp --use_num
```

#### 生成的文件

```
$ tree tmp/ -L 1
tmp
├── test-chain
├── test-chain-0
├── test-chain-1
├── test-chain-2
└── test-chain-3

5 directories, 0 files
```

#### 编译工程

```
$ make release
```

会将编译二进制和配置文件放到 `target/install` 目录下。

#### 脚本执行

链启动

```
$ cd target/install

$ ./scripts/env.sh start config/test-chain-0 50000 && ./scripts/env.sh start config/test-chain-1 51000 && ./scripts/env.sh start config/test-chain-2 52000 && ./scripts/env.sh start config/test-chain-3 53000
```

链停止

```
$ ./scripts/env.sh stop
```

链文件删除

```
$ ./scripts/env.sh clean config/test-chain-0 && ./scripts/env.sh clean config/test-chain-1 && ./scripts/env.sh clean config/test-chain-2 && ./scripts/env.sh clean config/test-chain-3