# runner_local

runner_local 是 `cita-cloud` 的集合工程，通过 `.gitmodules` 将 cita-cloud 的各个工程融合进来，以及改造 `cita_cloud_config` 实现宿主机的 local 执行。

### 依赖

依赖请参看所有子工程的依赖文档。

### 使用方法

```
$ ./config/cita_cloud_config.py -h
usage: cita_cloud_config.py [-h] [--timestamp TIMESTAMP] [--block_delay_number BLOCK_DELAY_NUMBER] [--chain_name CHAIN_NAME]
                            [--peers_count PEERS_COUNT] [--kms_password KMS_PASSWORD] [--enable_tls] [--is_stdout]
                            [--log_level LOG_LEVEL] [--is_bft] [--is_local]

optional arguments:
  -h, --help            show this help message and exit
  --timestamp TIMESTAMP
                        Timestamp of genesis block.
  --block_delay_number BLOCK_DELAY_NUMBER
                        The block delay number of chain.
  --chain_name CHAIN_NAME
                        The name of chain.
  --peers_count PEERS_COUNT
                        Count of peers.
  --kms_password KMS_PASSWORD
                        Password of kms.
  --enable_tls          Is enable tls
  --is_stdout           Is output to stdout
  --log_level LOG_LEVEL
                        log level: warn/info/debug/trace
  --is_bft              Is bft
  --is_local            Is running in local
```

### 例子

```
$ ./config/cita_cloud_config.py --peers_count 3 --kms_password 123456 --is_bft --is_local
args: Namespace(block_delay_number=0, chain_name='test-chain', enable_tls=False, is_bft=True, is_local=True, is_stdout=False, kms_password='123456', log_level='info', peers_count=3, timestamp=None)
peers: [{'ip': '127.0.0.1', 'port': 40000}, {'ip': '127.0.0.1', 'port': 40001}, {'ip': '127.0.0.1', 'port': 40002}]
net_config_list: [{'enable_tls': False, 'port': 40000, 'peers': [{'ip': '127.0.0.1', 'port': 40001}, {'ip': '127.0.0.1', 'port': 40002}]}, {'enable_tls': False, 'port': 40001, 'peers': [{'ip': '127.0.0.1', 'port': 40000}, {'ip': '127.0.0.1', 'port': 40002}]}, {'enable_tls': False, 'port': 40002, 'peers': [{'ip': '127.0.0.1', 'port': 40000}, {'ip': '127.0.0.1', 'port': 40001}]}]
kms create output: key_id:1,address:0xd6eb91100f5ae6ff68f1495a5b7b71aa6f538f72
kms create output: key_id:1,address:0xf7f742bf08c927b1f92f294dd57b6ca0275df0dd
kms create output: key_id:1,address:0x33ec7e6bd2ef44e651ededd6bca5fddfcf09e866
kms create output: key_id:1,address:0x45482fe90366fbcb266776e72c1c40ce73652cee
Done!!!
```

产生的文件会在 `tmp` 目录下。

```
$ tree tmp/ -L 1
tmp/
├── admin
├── test-chain-0
├── test-chain-1
└── test-chain-2
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

$ ./script/env.sh start test-chain-0 50000 && ./script/env.sh start test-chain-1 60000 && ./script/env.sh start test-chain-2 70000
```

链停止

```
$ ./script/env.sh stop
```

链文件删除

```
$ ./script/env.sh clean test-chain-0 && ./script/env.sh clean test-chain-1 && ./script/env.sh clean test-chain-2
```

