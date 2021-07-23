# runner_local

runner_local 是 `cita-cloud` 的集合工程，通过 `.gitmodules` 将 cita-cloud 的各个工程融合进来，实现宿主机的 local 执行。

### 克隆子工程

```
git submodule update --init
```

### 依赖

依赖请参看所有子工程的依赖文档。

### 使用方法

```
usage: cita_cloud_config.py [-h] {init,increase,decrease,clean} ...

optional arguments:
  -h, --help            show this help message and exit

subcommands:
  {init,increase,decrease,clean}
                        additional help
    init                Init a chain.
    increase            Increase one node.
    decrease            Decrease one node.
    clean               Clean a chain.
ypf:~/ypf-app/rust/runner_local[15:13:39]$ ./config/cita_cloud_config.py init -h
usage: cita_cloud_config.py init [-h] [--work_dir WORK_DIR] [--timestamp TIMESTAMP] [--block_delay_number BLOCK_DELAY_NUMBER]
                                 [--chain_name CHAIN_NAME] [--peers_count PEERS_COUNT] [--nodes NODES] [--super_admin SUPER_ADMIN]
                                 [--kms_passwords KMS_PASSWORDS] [--enable_tls ENABLE_TLS] [--is_stdout IS_STDOUT] [--log_level LOG_LEVEL]
                                 [--is_bft IS_BFT] [--is_local IS_LOCAL]

optional arguments:
  -h, --help            show this help message and exit
  --work_dir WORK_DIR   The output director of node config files.
  --timestamp TIMESTAMP
                        Timestamp of genesis block.
  --block_delay_number BLOCK_DELAY_NUMBER
                        The block delay number of chain.
  --chain_name CHAIN_NAME
                        The name of chain.
  --peers_count PEERS_COUNT
                        Count of peers.
  --nodes NODES         Node network addr list.
  --super_admin SUPER_ADMIN
                        Address of super admin.
  --kms_passwords KMS_PASSWORDS
                        Password list of kms.
  --enable_tls ENABLE_TLS
                        Is enable tls
  --is_stdout IS_STDOUT
                        Is output to stdout
  --log_level LOG_LEVEL
                        log level: warn/info/debug/trace
  --is_bft IS_BFT       Is bft
  --is_local IS_LOCAL   Is running in local machine
```

### 例子

```
$ ./config/cita_cloud_config.py init --peers_count 4 --kms_password 123456 --is_bft true --is_local true
args: Namespace(block_delay_number=0, chain_name='test-chain', enable_tls=True, is_bft=True, is_local=True, is_stdout=False, kms_passwords='123456', log_level='info', nodes=None, peers_count=4, subcmd='init', super_admin=None, timestamp=None, work_dir='./tmp')
peers: [{'ip': '127.0.0.1', 'port': 40000}, {'ip': '127.0.0.1', 'port': 40001}, {'ip': '127.0.0.1', 'port': 40002}, {'ip': '127.0.0.1', 'port': 40003}]
net_config_list: [{'enable_tls': True, 'port': 40000, 'peers': [{'ip': '127.0.0.1', 'port': 40001}, {'ip': '127.0.0.1', 'port': 40002}, {'ip': '127.0.0.1', 'port': 40003}]}, {'enable_tls': True, 'port': 40001, 'peers': [{'ip': '127.0.0.1', 'port': 40000}, {'ip': '127.0.0.1', 'port': 40002}, {'ip': '127.0.0.1', 'port': 40003}]}, {'enable_tls': True, 'port': 40002, 'peers': [{'ip': '127.0.0.1', 'port': 40000}, {'ip': '127.0.0.1', 'port': 40001}, {'ip': '127.0.0.1', 'port': 40003}]}, {'enable_tls': True, 'port': 40003, 'peers': [{'ip': '127.0.0.1', 'port': 40000}, {'ip': '127.0.0.1', 'port': 40001}, {'ip': '127.0.0.1', 'port': 40002}]}]
kms_passwords:  ['123456', '123456', '123456', '123456', '123456']
kms create output: key_id:1,address:0xd7b298efc720872514207abed24c60c97917fe8c
Done!!!
```

产生的文件会在 `tmp` 目录下。

```
$ tree tmp/ -L 1
tmp/
├── test-chain
├── test-chain-0
├── test-chain-1
├── test-chain-2
├── test-chain-3
└── test-chain.config

5 directories, 1 file
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
```
