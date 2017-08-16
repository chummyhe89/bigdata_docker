FROM centos 
MAINTAINER bigdata@icarevision.cn
#sshd
RUN yum install -y openssh-server iproute sudo openssh-clients which
RUN mkdir -p /var/run/sshd
RUN mkdir -p /root/.ssh
RUN ssh-keygen -q -t rsa -b 2048 -f /etc/ssh/ssh_host_rsa_key -N ''
RUN ssh-keygen -q -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N ''
RUN ssh-keygen -t dsa -f /etc/ssh/ssh_host_ed25519_key  -N '' 
EXPOSE 22
# common
ADD common.sh /common.sh
ADD run_app.sh /run_app.sh
ADD start_master.sh /start_master.sh
ADD start_slave.sh /start_slave.sh
RUN chmod 755 /common.sh /start_master.sh /start_slave.sh
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
# jdk
ADD jdk /opt/jdk
ENV JAVA_HOME /opt/jdk
# hadoop
ADD hadoop /opt/hadoop
ENV HADOOP_HOME /opt/hadoop 
#zk
ADD zookeeper /opt/zookeeper
ENV ZK_HOME /opt/zookeeper
#es
ADD elasticsearch /opt/elasticsearch 
#hbase
ADD hbase /opt/hbase
ENV HBASE_HOME /opt/hbase
#kafka
ADD kafka /opt/kafka
ENV KAFKA_HOME /opt/kafka
#kafka_monitor
ADD kafka_monitor /opt/kafka_monitor
#tomcat
ADD tomcat /opt/tomcat
#spark
ADD spark /opt/spark
#redis
ADD redis /opt/redis
#PATH
ENV PATH /usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/opt/jdk/bin:/opt/jdk/bin:/opt/zookeeper/bin:/opt/hadoop/bin:/opt/hbase/bin:/opt/kafka/bin:/home/hadoop/bin
RUN mkdir -p /bigdata/tmp/hdfs /bigdata/meta/hdfs/journal /bigdata/meta/hdfs/nn /data/hdfs/dn /data/yarn/local /bigdata/logs/yarn /data/kafka /data/es/data /bigdata/logs/es
#add hadoop user
RUN groupadd hadoop
RUN useradd -m -s /bin/bash -g hadoop hadoop
RUN echo "123456" |passwd --stdin hadoop
RUN echo "hadoop ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN echo 'export PATH=/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/opt/jdk/bin:/opt/jdk/bin:/opt/zookeeper/bin:/opt/hadoop/bin:/opt/hbase/bin:/opt/kafka/bin:/home/hadoop/bin' >> /home/hadoop/.bashrc
RUN chown -R hadoop.hadoop /bigdata /opt /data
#RUN echo -e "*       soft    nofile    65535\n*       hard    nofile    65535\n*       soft   memlock   51200000\n*       hard   memlock   51200000"  >> /etc/security/limits.conf
RUN echo "hadoop          soft    nproc     65536" >> /etc/security/limits.d/20-nproc.conf
CMD ["/start_slave.sh"]
