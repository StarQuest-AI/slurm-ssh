#!/bin/bash

time=0
cpus=8
mem=4G
gpu=0
job_name=example
partition=train
output=slurm-ssh.log

help_message=$(cat << EOF
Usage: slurm-ssh <port>
e.g. slurm-ssh 6006
Options:
  --time <d-hh:mm:ss> # 指定时间限制 (默认: 0, 表示无限制)
  --cpus              # 指定 CPU 核心数 (默认: 1)
  --mem               # 指定内存大小 (默认: 4G)
  --gpu               # 指定 GPU 数量 (默认: 0)
  --job_name          # 指定任务名字 (默认: example)
  --partition         # 指定分区 (默认: train)
  --output            # 指定输出文件 (默认: slurm-ssh.log)
EOF
)

. parse_options.sh

if [ $# != 1 ]; then
  echo "${help_message}" 1>&2
  exit 1;
fi

port=$1

envsubst <<EOF | sbatch
#!/bin/bash

#SBATCH --time $time
#SBATCH --job-name $job_name
#SBATCH --cpus-per-task $cpus
#SBATCH --mem ${mem}
#SBATCH --partition $partition
#SBATCH --gres gpu:$gpu
#SBATCH --output $output

### store relevant environment variables to a file in the home folder
env | awk -F= '\$1~/^(SLURM|CUDA|NVIDIA_)/{print "export "\$0}' > ~/.slurm-envvar.bash

# here we make sure to remove this file when this SLURM job terminates
cleanup() {
    echo "Caught signal - removing SLURM env file"
    rm -f ~/.slurm-envvar.bash
}
trap 'cleanup' SIGTERM

# dropbearkey -t ecdsa -s 521 -f ~/.ssh/server-key
dropbear -r ~/.ssh/server-key -F -E -w -s -p $port
EOF
