# slurm-ssh

## Usage

``` bash
$ bash init.sh  # 安装 dropbear & 生成密钥对和配置登录权限，只运行一次即可
$ export PORT=2222
$ bash run.sh --cpus 8 --mem 16G --gpu 1 --job_name myjob --partition compute $PORT
```
