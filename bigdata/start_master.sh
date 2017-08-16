#!/bin/bash
sh /common.sh

echo "127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4" >> /opt/share/hosts
scp /opt/share/hosts root@node1:/etc/hosts
scp /opt/share/hosts root@node2:/etc/hosts
scp /opt/share/hosts root@node3:/etc/hosts
scp /opt/share/hosts root@node4:/etc/hosts

#ssh root@node1 'chown -R hadoop.hadoop /home/hadoop/.ssh;chmod 600 /home/hadoop/.ssh/authorized_keys'
#ssh root@node2 'chown -R hadoop.hadoop /home/hadoop/.ssh;chmod 600 /home/hadoop/.ssh/authorized_keys'
#ssh root@node3 'chown -R hadoop.hadoop /home/hadoop/.ssh;chmod 600 /home/hadoop/.ssh/authorized_keys'
#ssh root@node4 'chown -R hadoop.hadoop /home/hadoop/.ssh;chmod 600 /home/hadoop/.ssh/authorized_keys'

# zk
su - hadoop -c "ssh hadoop@node1 '/opt/zookeeper/bin/zkServer.sh start'"
su - hadoop -c "ssh hadoop@node2 '/opt/zookeeper/bin/zkServer.sh start'"
su - hadoop -c "ssh hadoop@node3 '/opt/zookeeper/bin/zkServer.sh start'"

# hadoop
su - hadoop -c "ssh hadoop@node1 '/opt/hadoop/sbin/hadoop-daemon.sh start journalnode'"
su - hadoop -c "ssh hadoop@node2 '/opt/hadoop/sbin/hadoop-daemon.sh start journalnode'"
su - hadoop -c "ssh hadoop@node3 '/opt/hadoop/sbin/hadoop-daemon.sh start journalnode'"
su - hadoop -c "ssh hadoop@node1 '/opt/hadoop/bin/hdfs namenode -format mycluster -force'"
su - hadoop -c "ssh hadoop@node1 '/opt/hadoop/bin/hdfs zkfc -formatZK -force'"
su - hadoop -c "ssh hadoop@node1 '/opt/hadoop/sbin/hadoop-daemon.sh start namenode'"
su - hadoop -c "ssh hadoop@node2 '/opt/hadoop/bin/hdfs namenode -bootstrapStandby -force'"
su - hadoop -c "ssh hadoop@node2 '/opt/hadoop/sbin/hadoop-daemon.sh start namenode'"
su - hadoop -c "ssh hadoop@node1 '/opt/hadoop/sbin/start-dfs.sh'"
su - hadoop -c "ssh hadoop@node1 '/opt/hadoop/sbin/start-yarn.sh'"
su - hadoop -c "ssh hadoop@node2 '/opt/hadoop/sbin/start-yarn.sh'"
su - hadoop -c "ssh hadoop@node4 '/opt/hadoop/sbin/mr-jobhistory-daemon.sh start historyserver'"
# hbase
su - hadoop -c "/opt/hbase/bin/start-hbase.sh"
# kafka
su - hadoop -c "ssh hadoop@node1 '/opt/kafka/bin/kafka-server-start.sh -daemon /opt/kafka/config/server.properties'"
su - hadoop -c "ssh hadoop@node2 '/opt/kafka/bin/kafka-server-start.sh -daemon /opt/kafka/config/server.properties'"
su - hadoop -c "ssh hadoop@node3 '/opt/kafka/bin/kafka-server-start.sh -daemon /opt/kafka/config/server.properties'"
su - hadoop -c "ssh hadoop@node4 '/opt/kafka/bin/kafka-server-start.sh -daemon /opt/kafka/config/server.properties'"
# kafka monitor
su - hadoop -c "cd /opt/kafka_monitor ;/bin/bash  /opt/kafka_monitor/start.sh"
# redis
su - hadoop -c "ssh hadoop@node4 '/opt/redis/redis-server /opt/redis/redis.conf >/dev/null 2>&1 &'"
# elasticsearch
su - hadoop -c "ssh hadoop@node1 'sed -i \"/node.name/s/node.name.*/node.name: node1/g\" /opt/elasticsearch/config/elasticsearch.yml; /opt/elasticsearch/bin/elasticsearch -d'"
su - hadoop -c "ssh hadoop@node2 'sed -i \"/node.name/s/node.name.*/node.name: node2/g\" /opt/elasticsearch/config/elasticsearch.yml; /opt/elasticsearch/bin/elasticsearch -d'"
su - hadoop -c "ssh hadoop@node3 'sed -i \"/node.name/s/node.name.*/node.name: node3/g\" /opt/elasticsearch/config/elasticsearch.yml; /opt/elasticsearch/bin/elasticsearch -d'"
su - hadoop -c "ssh hadoop@node4 'sed -i \"/node.name/s/node.name.*/node.name: node4/g\" /opt/elasticsearch/config/elasticsearch.yml; /opt/elasticsearch/bin/elasticsearch -d'"
# tomcat
su - hadoop -c "ssh hadoop@node4 ' /opt/tomcat/bin/startup.sh &'"

ping 127.0.0.1 > /dev/null 2>&1
