# Yolov5_DeepSort_Traffic-counter
基于Yolov5_DeepSort的移动物体计数器，可以统计车流或人流量等  
本作品基于此项目实现：https://github.com/owo12321/Yolov5_DeepSort_Traffic-counter 在它的基础上做了一些改动，实现门店人流统计。

20240203版本更新如下：

      -- 因终端设备性能问题增加了一个每4个小时重启电脑的设置，以临时释放终端运行压力

20240124版本更新如下：

      -- 修正了一个在异常断电时可能存在16进制写0的异常输出导致无法正常启动的问题

20240108版本更新如下：

      -- 增加了店铺ID字段store_id，以方便以店铺ID方式上报到上游接口
         -- 路径：store_configs/store_name.yaml
         -- 字段：store_id: "店铺ID"
      -- 调整number-<时间戳>.txt 文件，增加store_id字段
      -- 启动程序(launcher.sh)增加上传接口数据功能

20231129版本更新如下：

      -- 现在可以在配置文件中配置门店名称，方便安装部署。
         --路径：store_configs/store_config.yaml
         --字段：store: "店铺名"

20231124版本更新如下：

      -- 优化了number-<时间戳>.txt 文件创建逻辑，现在不会生成多个文件，按每日一个文件保存。
      -- 修复了启动程序不能正确处理跨日期运行将total_num重置为0的问题。

20231121版本更新如下：

      -- 针对人流监控增加了时间戳以方便按时间统计人流数量。

      -- 针对人流监控增加了门店名以方便按门店统计人流数量。

      -- 固化了requirements.txt文件中部分依赖的版本，修复了因为numpy更新导致的函数库问题。

      -- 补充了以下逻辑：

         -- 移除删除output文件并重新生成行为。

         -- 在number.txt文件后方增加生成时间戳，即运行内容可以保存与查看。

         -- 当软件或系统因手动或意外重新运行时，将查找先前文件并继承统计结果，即统计结果不因为意外请零。

      -- 增加了一个启动程序(launcher.sh)以方便运行，并防止跨日运行，当出现跨日期时，将自动运行软件，以保证每日的number.txt不会因此受到污染。

![image](https://github.com/owo12321/Yolov5_DeepSort_Traffic-counter/blob/main/test.gif)

## 1、环境配置
下载项目文件夹后，在命令行中进入项目文件夹，执行以下代码配置环境：
```
python3 -m venv deepsort
```
```
source deepsort/bin/activate
```
```
下载:https://github.com/lxopencv/Yolov5_DeepSort_Traffic-counter/releases/download/Store-statistics/Yolov5_DeepSort_Traffic-counter.zip
```
```
cd ~/Yolov5_DeepSort_Traffic-counter/ 
```
```
pip install -r requirements.txt
```

## 2、检测原理
Yolov5_DeepSort会跟踪画面上检测出来的物体，并给每个框标上了序号，当有一个方框跨过检测线时，计数器就会+1  
用户可以指定检测线的画法，可以指定框沿哪个方向跨过检测线时计数器+1，也可以指定框的四个顶点中的哪一个顶点跨过线时计数器+1  
具体的参数设定见第3点


## 3、参数设置
在count.py中，设置以下参数
```
source_dir : 要打开的视频文件。若要调用摄像头，需要设置为字符串'0'，而不是数字0，按q退出播放
output_dir : 要保存到的文件夹
store_name ：由store_configs/store_config.yaml配置店铺名
store_id ：由store_configs/store_config.yaml配置店铺id
show_video : 运行时是否显示
save_video : 是否保存运行结果视频
save_text :  是否保存结果数据到txt文件中，将会保存两个文本文件：result.txt和number.txt。result.txt的格式是(帧序号,框序号,框到左边距离,框到顶上距离,框横长,框竖高,-1,-1,-1,-1)，number.txt的格式是(店铺名，时间戳，帧序号，直至当前帧跨过线的框数)

class_list : 要检测的类别序号，在coco_classes.txt中查看（注意是序号不是行号），可以有一个或多个类别

line : 检测线的两个端点的xy坐标，总共4个数
big_to_small : 0表示从比线小的一侧往大的一侧，1反之。（靠近坐原点或坐标轴的一侧是小的）
point_idx : 要检测的方框顶点号(0, 1, 2, 3)，看下边的图，当方框的顶点顺着big_to_small指定的方向跨过检测线时，计数器会+1
```

检测线的画法：给出两个端点的坐标，确定一条检测线，画布的坐标方向如下
```
   |-------> x轴
   |
   |
   V
   y轴
```

方框的顶点编号：当方框的指定顶点跨过检测线时，计数器会+1，顶点的编号如下
```
   0              1
   |--------------|
   |              |
   |              |
   |--------------|
   3              2
```

## 4、运行
设置好参数（门店名，运行显示）后，运行文件夹内launcher.sh文件即可
```
./launcher.sh
```
