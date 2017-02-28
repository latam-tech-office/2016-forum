oc delete pv --all 
systemctl restart rpcbind; systemctl restart nfs-server
oc create -n devops -f -<<EOF
apiVersion: v1
kind: List
items:
- apiVersion: v1
  kind: PersistentVolume
  metadata:
    name: gogs-data
  spec:
    capacity:
      storage: 50Gi
    accessModes:
      - ReadWriteOnce
      - ReadWriteMany
    nfs:
      server: 192.168.56.101
      path: /opt/storage/gogs/data
    persistentVolumeReclaimPolicy: Recycle
- apiVersion: v1
  kind: PersistentVolumeClaim
  metadata:
    name: gogs-data
  spec:
    accessModes:
      - ReadWriteOnce
      - ReadWriteMany
    resources:
      requests:
        storage: 50Gi
EOF

oc create -n devops -f -<<EOF
apiVersion: v1
kind: List
items:
- apiVersion: v1
  kind: PersistentVolume
  metadata:
    name: gogs-mysql
  spec:
    capacity:
      storage: 50Gi
    accessModes:
      - ReadWriteOnce
      - ReadWriteMany
    nfs:
      server: 192.168.56.101
      path: /opt/storage/gogs/mysql
    persistentVolumeReclaimPolicy: Recycle
- apiVersion: v1
  kind: PersistentVolumeClaim
  metadata:
    name: gogs-mysql
  spec:
    accessModes:
      - ReadWriteOnce
      - ReadWriteMany
    resources:
      requests:
        storage: 50Gi
EOF

oc create -n devops -f -<<EOF
apiVersion: v1
kind: List
items:
- apiVersion: v1
  kind: PersistentVolume
  metadata:
    name: jenkins
  spec:
    capacity:
      storage: 50Gi
    accessModes:
      - ReadWriteOnce
      - ReadWriteMany
    nfs:
      server: 192.168.56.101
      path: /opt/storage/jenkins
    persistentVolumeReclaimPolicy: Recycle
- apiVersion: v1
  kind: PersistentVolumeClaim
  metadata:
    name: jenkins
  spec:
    accessModes:
      - ReadWriteOnce
      - ReadWriteMany
    resources:
      requests:
        storage: 50Gi
EOF

oc create -n devops -f -<<EOF
apiVersion: v1
kind: List
items:
- apiVersion: v1
  kind: PersistentVolume
  metadata:
    name: nexus
  spec:
    capacity:
      storage: 50Gi
    accessModes:
      - ReadWriteOnce
      - ReadWriteMany
    nfs:
      server: 192.168.56.101
      path: /opt/storage/nexus
    persistentVolumeReclaimPolicy: Recycle
- apiVersion: v1
  kind: PersistentVolumeClaim
  metadata:
    name: nexus
  spec:
    accessModes:
      - ReadWriteOnce
      - ReadWriteMany
    resources:
      requests:
        storage: 50Gi
EOF
