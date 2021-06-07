# runner_local

runner_local 是 `cita-cloud` 的集合工程，通过 `.gitmodules` 将 cita-cloud 的各个工程融合进来，以及改造 `cita_cloud_config` 实现宿主机的 local 执行。

### 克隆子工程

```
git submodule update --init
```

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
$ ./config/cita_cloud_config.py --peers_count 2 --kms_password 123456 --is_bft --is_local
  args: Namespace(block_delay_number=0, chain_name='test-chain', enable_tls=False, is_bft=True, is_local=True, is_stdout=False, kms_password='123456', log_level='info', peers_count=2, timestamp=None)
  peers: [{'ip': '127.0.0.1', 'port': 40000}, {'ip': '127.0.0.1', 'port': 40001}]
  net_config_list: [{'enable_tls': False, 'port': 40000, 'peers': [{'ip': '127.0.0.1', 'port': 40001}]}, {'enable_tls': False, 'port': 40001, 'peers': [{'ip': '127.0.0.1', 'port': 40000}]}]
  kms create output: key_id:1,address:0x6eee3fdcf3209af4f4292d7d2d0f8838988982c1
  kms create output: key_id:1,address:0x6ba08d0c5f04538fc7d392d5c0917ce32c630c0e
  kms create output: key_id:1,address:0x5fa8fb233366b9ce1cdb28114852e6cc5871383b
  Done!!!
```

产生的文件会在 `tmp` 目录下。

```
$ tree tmp/ -L 1
tmp/
├── admin
├── test-chain-0
├── test-chain-1
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

$ ./scripts/env.sh start config/test-chain-0 50000 && ./scripts/env.sh start config/test-chain-1 60000
```

链停止

```
$ ./scripts/env.sh stop
```

链文件删除

```
$ ./scripts/env.sh clean config/test-chain-0 && ./scripts/env.sh clean config/test-chain-1
```
