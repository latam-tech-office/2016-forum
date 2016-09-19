mkdir -p ${1}
chown -R nfsnobody:nfsnobody ${1}
chmod -R 777 ${1}
echo "${1} *(rw,sync,no_root_squash)" >> /etc/exports
systemctl restart nfs-server; systemctl restart rpcbind
oc create -f -<<EOF
apiVersion: v1
kind: PersistentVolume
metadata:
  name: ${2}
spec:
  capacity:
    storage: 2Gi
  accessModes:
    - ReadWriteOnce
    - ReadWriteMany
  nfs:
    server: 192.168.56.100
    path: ${1}
  persistentVolumeReclaimPolicy: Recycle
EOF
