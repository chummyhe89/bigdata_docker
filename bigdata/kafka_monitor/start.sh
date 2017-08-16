#!/bin/bash
nohup java -Xms64M -Xmx128M -Xss1024K -XX:PermSize=64m -XX:MaxPermSize=128m \
-cp /opt/kafka_monitor/KafkaOffsetMonitor-assembly-0.2.0.jar \
com.quantifind.kafka.offsetapp.OffsetGetterWeb \
--zk node1:2181,node2:2181,node3:2181 \
--port 8086 \
--refresh 10.seconds \
--retain 7.days 1>>/opt/kafka_monitor/logs/stdout.log 2>>/opt/kafka_monitor/logs/stderr.log &
