## 准备Rust
Rust 1.62.0+

```
# install rust
$ curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# install system package
$ apt install -y --no-install-recommends make git protobuf-compiler libssl-dev pkg-config clang
```

## 获取子模块
在获取子模块之前可以发现，runner_local里的子模块都是空的。首先修改`.gitmodules`文件来指定要获取的微服务及其版本分支，默认的`Consensus`微服务是`Overlord`，默认的`Crpto`微服务是`Sm`，所有微服务都默认使用主分支。然后用一下命令获取子模块，注意：需要翻墙。

```
git submodule update --force --init --remote --recursive
```

## 生成配置

安装 cloud-config

```
cargo install --path config
```

本地运行用`create-dev`子命令生成配置文件，默认的`Consensus`配置是`Overlord`，默认的`Crpto`微服务是`Sm`

```
$ cloud-config create-dev -h
create config in env dev

Usage: cloud-config create-dev [OPTIONS]

Options:
      --chain-name <CHAIN_NAME>
          set chain name [default: test-chain]
      --config-dir <CONFIG_DIR>
          set config file directory, default means current directory [default: .]
      --peers-count <PEERS_COUNT>
          set initial node number [default: 4]
      --log-level <LOG_LEVEL>
          log level [default: info]
      --log-file-path <LOG_FILE_PATH>
          log file path [default: ./logs]
      --jaeger-agent-endpoint <JAEGER_AGENT_ENDPOINT>
          jaeger agent endpoint
      --is-raft
          is consensus raft
      --is-eth
          is crypto eth
      --is-danger
          is chain in danger mode
      --disable-metrics
          disable metrics
  -h, --help
          Print help
```

通过以下命令生成默认配置

```
$ cloud-config create-dev --config-dir tmp
```

查看生成的文件

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

## 编译工程

```
$ make release
```

会将编译二进制和上一步生成的配置文件放到 `target/install` 目录下。

## 运行Cita-Cloud

zenoh 需要监听域名, 将其添加到hosts文件中

```
$ echo '127.0.0.1 test-chain-0' | sudo tee -a /etc/hosts
$ echo '127.0.0.1 test-chain-1' | sudo tee -a /etc/hosts
$ echo '127.0.0.1 test-chain-2' | sudo tee -a /etc/hosts
$ echo '127.0.0.1 test-chain-3' | sudo tee -a /etc/hosts
```

切换至`target/install` 目录下
```
$ cd target/install
```

`scripts/env.sh`是一个包含启动、停止、清除数据操作的脚本

```
$ scripts/env.sh --help
Usage: env.sh <command>
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
```

启动所有节点

```
$ ./scripts/env.sh start
```

停止所有节点

```
$ ./scripts/env.sh stop
```

清除所有节点数据

```
$ ./scripts/env.sh clean
```

以上命令也可以对指定节点操作，比如以下命令就是启动0号和2号节点：

```
$ ./scripts/env.sh start 0 2
```
