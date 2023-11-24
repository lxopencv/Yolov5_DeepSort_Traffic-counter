#!/bin/bash

cd

# 激活 deepsort 环境
source ~/deepsort/bin/activate

# 进入 Yolov5_DeepSort_Traffic-counter 目录
cd ~/Yolov5_DeepSort_Traffic-counter/

# 当前日期
current_date=$(date +"%Y%m%d")

# 启动 upcount_v6.py 脚本
python upcount_v6.py &

# 获取 upcount_v6.py 的进程 ID
pid=$!

# 循环直到日期变化
while true; do
    # 每分钟检查最新的 number-<时间戳>.txt 文件
    latest_file=$(ls -t inference/output/number-*.txt | head -n 1)
    if [[ -n "$latest_file" ]]; then
        echo "最新数据:"
        tail -n1 "$latest_file"
    fi

    sleep 60

    # 检查日期是否变化
    new_date=$(date +"%Y%m%d")
    if [[ "$new_date" != "$current_date" ]]; then
        echo "日期变化，重新启动脚本..."

        # 杀死当前运行的 python 脚本
        kill $pid

        # 更新日期
        current_date=$new_date

        # 重新启动 upcount_v6.py 脚本
        python upcount_v6.py &
        pid=$!
    fi
done
