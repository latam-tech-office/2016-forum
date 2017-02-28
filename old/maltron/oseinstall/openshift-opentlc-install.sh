echo ">>> [1/1] oselab: Setting the Repositories"
cat << EOF > /etc/yum.repos.d/openshift.repo
[rhel-7-server-rpms]
name=Red Hat Enterprise Linux 7
baseurl=http://oselab.example.com/repos/3.2/rhel-7-server-rpms http://www.opentlc.com/repos/ose/3.2/rhel-7-server-rpms
enabled=1
gpgcheck=0

[rhel-7-server-rh-common-rpms]
name=Red Hat Enterprise Linux 7 Common
baseurl=http://oselab.example.com/repos/3.2/rhel-7-server-rh-common-rpms http://www.opentlc.com/repos/ose/3.2/rhel-7-server-rh-common-rpms
enabled=1
gpgcheck=0

[rhel-7-server-extras-rpms]
name=Red Hat Enterprise Linux 7 Extras
baseurl=http://oselab.example.com/repos/3.2/rhel-7-server-extras-rpms http://www.opentlc.com/repos/ose/3.2/rhel-7-server-extras-rpms
enabled=1
gpgcheck=0

[rhel-7-server-optional-rpms]
name=Red Hat Enterprise Linux 7 Optional
baseurl=http://oselab.example.com/repos/3.2/rhel-7-server-optionak-rpms http://www.opentlc.com/repos/ose/3.2/rhel-7-server-optional-rpms
enabled=1
gpgcheck=0

[rhel-7-server-ose-3.2-rpms]
name=Red Hat Enterprise Linux 7 OSE 3.2
baseurl=http://oselab.example.com/repos/3.2/rhel-7-server-ose-3.2-rpms http://www.opentlc.com/repos/ose/3.2/rhel-7-server-ose-3.2-rpms
enabled=1
gpgcheck=0
EOF

echo ">>> [2/15] oselab: Updating repositories and updating. Installing DNS Server"
yum clean all; yum repolist; yum -y update; yum -y install bind bind-utils bash-completion vim

export GUID=`hostname|cut -f2 -d-|cut -f1 -d.`
export guid=`hostname|cut -f2 -d-|cut -f1 -d.`
HostIP=`host infranode00-$GUID.oslab.opentlc.com  ipa.opentlc.com |grep infranode | awk '{print $4}'`
domain="cloudapps-$GUID.oslab.opentlc.com"

echo ">>> [3/15] oselab: Updating /etc/hosts with IP of each host"
cat << EOF >> /etc/hosts
192.168.0.100 master00-${GUID}.oslab.opentlc.com master00-${GUID}
192.168.0.101 infranode00-${GUID}.oslab.opentlc.com infranode00-${GUID}
192.168.0.200 node00-${GUID}.oslab.opentlc.com node00-${GUID}
192.168.0.201 node01-${GUID}.oslab.opentlc.com node01-${GUID}
EOF

echo ">>> [4/15] oselab: Updating /etc/hosts on Master, InfraNode, Node00 and Node01"
for node in master00-${GUID}.oslab.opentlc.com infranode00-${GUID}.oslab.opentlc.com node00-${GUID}.oslab.opentlc.com node01-${GUID}.oslab.opentlc.com; do ssh ${node} "cat << EOF >> /etc/hosts
192.168.0.100 master00-${GUID}.oslab.opentlc.com master00-${GUID}
192.168.0.101 infranode00-${GUID}.oslab.opentlc.com infranode00-${GUID}
192.168.0.200 node00-${GUID}.oslab.opentlc.com node00-${GUID}
192.168.0.201 node01-${GUID}.oslab.opentlc.com node01-${GUID}
EOF"; done

echo StrictHostKeyChecking no >> /etc/ssh/ssh_config
ssh master00-${GUID} "echo StrictHostKeyChecking no >> /etc/ssh/ssh_config"

echo ">>> [5/15] Updating repositories, updating, removing NetworkManager and installing Docker"
for node in master00-${GUID}.oslab.opentlc.com infranode00-${GUID}.oslab.opentlc.com node00-${GUID}.oslab.opentlc.com node01-${GUID}.oslab.opentlc.com; do scp /etc/yum.repos.d/open.repo ${node}:/etc/yum.repos.d/open.repo; ssh ${node} "yum clean all; yum repolist; yum -y update"; ssh ${node} "systemctl stop firewalld; systemctl disable firewalld; yum -y remove NetworkManager*; yum -y install docker"; done

echo ">>> [6/15] Updating /etc/sysconfig/docker allowing insecure-registry IP"
for node in master00-${GUID}.oslab.opentlc.com infranode00-${GUID}.oslab.opentlc.com node00-${GUID}.oslab.opentlc.com node01-${GUID}.oslab.opentlc.com; do ssh ${node} "sed -i \"s/OPTIONS.*/OPTIONS='--selinux-enabled --insecure-registry 172.30.0.0\/16'/\" /etc/sysconfig/docker" ; done

echo ">>> [7/15] Stopping Docker and removing content from /var/lib/docker/*"
for node in master00-${GUID}.oslab.opentlc.com infranode00-${GUID}.oslab.opentlc.com node00-${GUID}.oslab.opentlc.com node01-${GUID}.oslab.opentlc.com; do ssh ${node} "systemctl stop docker; rm -rf /var/lib/docker/*" ; done

echo ">>> [8/15] Configuring /etc/sysconfig/docker-storage/setup"
for node in master00-${GUID}.oslab.opentlc.com infranode00-${GUID}.oslab.opentlc.com node00-${GUID}.oslab.opentlc.com node01-${GUID}.oslab.opentlc.com; do ssh ${node} "cat <<EOF > /etc/sysconfig/docker-storage-setup
DEVS=/dev/vdb
VG=docker-vg
EOF"; done

echo ">>> [9/15] Running docker-storage-setup, Starting and Enabling Docker"
for node in master00-${GUID}.oslab.opentlc.com infranode00-${GUID}.oslab.opentlc.com node00-${GUID}.oslab.opentlc.com node01-${GUID}.oslab.opentlc.com; do ssh ${node} "docker-storage-setup; systemctl start docker; systemctl enable docker" ; done

echo ">>> [10/15] Installing all the necessary applications on Master"
ssh master00-${GUID}.oslab.opentlc.com "yum -y install wget git net-tools bind-utils iptables-services bridge-utils bash-completion httpd-tools atomic-openshift-utils nfs-server rpcbind"


echo ">>> [11/15] oselab: Creating directory /var/named/zones"
mkdir -p /var/named/zones

echo ">>> [12/15] oselab: Exporting definition for cloudapps"
echo "\$ORIGIN  .
\$TTL 1  ;  1 seconds (for testing only)
${domain} IN SOA master.${domain}.  root.${domain}.  (
  2011112904  ;  serial
  60  ;  refresh (1 minute)
  15  ;  retry (15 seconds)
  1800  ;  expire (30 minutes)
  10  ; minimum (10 seconds)
)
  NS master.${domain}.
\$ORIGIN ${domain}.
test A ${HostIP}
* A ${HostIP}"  >  /var/named/zones/${domain}.db

echo ">>> [13/15] oselab: Exporting definitions of DNS Server (/etc/named.conf)"
echo "// named.conf
options {
  listen-on port 53 { any; };
  directory \"/var/named\";
  dump-file \"/var/named/data/cache_dump.db\";
  statistics-file \"/var/named/data/named_stats.txt\";
  memstatistics-file \"/var/named/data/named_mem_stats.txt\";
  allow-query { any; };
  recursion yes;
  /* Path to ISC DLV key */
  bindkeys-file \"/etc/named.iscdlv.key\";
};
logging {
  channel default_debug {
    file \"data/named.run\";
    severity dynamic;
  };
};
zone \"${domain}\" IN {
  type master;
  file \"zones/${domain}.db\";
  allow-update { key ${domain} ; } ;
};" > /etc/named.conf

echo ">>> [14/15] oselab: Adjusting Permissions for DNS Server"
chgrp named -R /var/named ; \
 chown named -Rv /var/named/zones ; \
 restorecon -Rv /var/named ; \
 chown -v root:named /etc/named.conf ; \
 restorecon -v /etc/named.conf ;

echo ">>> [1/15] oselab: Starting and Enabling DNS Server"
systemctl enable named && \
 systemctl start named


