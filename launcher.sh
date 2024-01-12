#!/bin/bash

cd

# 激活 deepsort 环境
source ~/deepsort/bin/activate

# 进入 Yolov5_DeepSort_Traffic-counter 目录
cd ~/Yolov5_DeepSort_Traffic-counter/

# 启动 upcount_v6.py 脚本
python upcount_v6.py &
pid=$!

# 获取 store_id 一次，避免在循环中重复执行
store_id=$(grep 'store_id:' store_configs/store_name.yaml | awk '{print $2}' | tr -d '"')

# 组合循环以检查文件更新和日期变化
current_date=$(date +"%Y%m%d")
while true; do
    # 每分钟执行一次
    sleep 1

    # 检查最新的 number-<时间戳>.txt 文件
    latest_file=$(ls -t inference/output/number-*.txt | head -n 1)
    if [[ -n "$latest_file" ]]; then
        # 读取文件的最后一行并提取traffic_count
        last_line=$(tail -n 1 "$latest_file")
        traffic_count=$(echo $last_line | cut -d' ' -f5)

        # 使用当前系统时间作为date
        current_system_date=$(date +'%Y-%m-%d %H:%M:%S')

        # 构造JSON数据
        json_data="{\"store_id\": \"$store_id\", \"date\": \"$current_system_date\", \"traffic_count\": $traffic_count}"

        # 打印JSON数据
        echo "JSON data to be sent: $json_data"

        # 发送POST请求（暂时注释掉，便于测试）
        curl -X POST https://japi.semsx.com/Admin/StoreDailyTraffic/addTraffic -H "Content-Type: application/json" -d "$json_data"
    fi

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
