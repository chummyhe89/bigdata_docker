#!/bin/bash
/usr/sbin/sshd
# ssh
sudo -u hadoop ssh-keygen -t rsa -P "" -f /home/hadoop/.ssh/id_rsa -q
cat /home/hadoop/.ssh/id_rsa.pub >> /opt/share/authorized_keys
echo "StrictHostKeyChecking no" >> /home/hadoop/.ssh/config
echo "UserKnownHostsFile /dev/null" >> /home/hadoop/.ssh/config
ln -s /opt/share/authorized_keys /home/hadoop/.ssh/authorized_keys
chown -R hadoop.hadoop /opt/share/authorized_keys /home/hadoop/.ssh /opt
# ssh root
ssh-keygen -t rsa -P "" -f /root/.ssh/id_rsa -q
cat /root/.ssh/id_rsa.pub >> /root_ssh/authorized_keys
echo "StrictHostKeyChecking no" >> /root/.ssh/config
echo "UserKnownHostsFile /dev/null" >> /root/.ssh/config
chmod 0600 /root_ssh/authorized_keys
ln -s /root_ssh/authorized_keys /root/.ssh/authorized_keys

echo "HOSTNAME=${HOSTNAME}" > /etc/sysconfig/network
echo $(ip addr |grep -E 'inet.*eth0' | awk '{print $2}' |awk -F '/' '{print $1}')	$(hostname)  >> /opt/share/hosts
#zk id
echo ${ZK_ID} > /opt/zookeeper/data/myid
#kafka
sed -i "/broker.id/s/broker.id.*/broker.id: ${K_ID}/g" /opt/kafka/config/server.properties
