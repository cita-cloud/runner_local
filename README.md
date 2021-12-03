# cloud-config

创建链的配置文件。

### 依赖

```
# install rust
$ curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# install system package
# apt install -y --no-install-recommends make git protobuf-compiler libssl-dev pkg-config clang
```

### 安装 cloud-config

```
cargo install --path config
```

### 用法

```
$ cloud-config help
cloud-config 6.3.0

Rivtower Technologies.

USAGE:
    cloud-config <SUBCOMMAND>

FLAGS:
    -h, --help       Print help information
    -V, --version    Print version information

SUBCOMMANDS:
    append-dev           append node in env dev
    append-k8s           append node in env k8s
    append-node          append a node into chain
    append-validator     append a validator into chain
    create-ca            create CA
    create-csr           create csr
    create-dev           create config in env dev
    create-k8s           create config in env k8s
    delete-chain         delete a chain
    delete-dev           delete node in env dev
    delete-k8s           delete node in env k8s
    delete-node          delete a node from chain
    help                 Print this message or the help of the given subcommand(s)
    init-chain           init a chain
    init-chain-config    init chain config
    init-node            init node
    new-account          new account
    set-admin            set admin of chain
    set-nodelist         set node list
    set-validators       set validators of chain
    sign-csr             sign csr
    update-node          update node
```

### 初始化链 dev mode

```
$ cloud-config create-dev --help
cloud-config-create-dev 

create config in env dev

USAGE:
    cloud-config create-dev [FLAGS] [OPTIONS]

FLAGS:
    -h, --help       Print help information
        --is-bft     is consensus bft
        --is-tls     is network tls
    -V, --version    Print version information

OPTIONS:
        --chain-name <CHAIN_NAME>      set chain name [default: test-chain]
        --config-dir <CONFIG_DIR>      set config file directory, default means current directory
                                       [default: .]
        --log-level <LOG_LEVEL>        log level [default: info]
        --peers-count <PEERS_COUNT>    set initial node number [default: 4]
```

```
$ cloud-config create-dev --is-bft --config-dir tmp
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