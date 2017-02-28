oc create -f -<<EOF
apiVersion: v1
kind: List
items:
- apiVersion: v1
  kind: PersistentVolume
  metadata:
    name: storage1
  spec:
    capacity:
      storage: 5Gi
    accessModes:
      - ReadWriteOnce
      - ReadWriteMany
    nfs:
      server: 192.168.1.100
      path: /opt/persistence/storage1
    persistentVolumeReclaimPolicy: Recycle
- apiVersion: v1
  kind: PersistentVolume
  metadata:
    name: storage2
  spec:
    capacity:
      storage: 5Gi
    accessModes:
      - ReadWriteOnce
      - ReadWriteMany
    nfs:
      server: 192.168.1.100
      path: /opt/persistence/storage2
    persistentVolumeReclaimPolicy: Recycle
- apiVersion: v1
  kind: PersistentVolume
  metadata:
    name: storage3
  spec:
    capacity:
      storage: 5Gi
    accessModes:
      - ReadWriteOnce
      - ReadWriteMany
    nfs:
      server: 192.168.1.100
      path: /opt/persistence/storage3
    persistentVolumeReclaimPolicy: Recycle
- apiVersion: v1
  kind: PersistentVolume
  metadata:
    name: storage4
  spec:
    capacity:
      storage: 5Gi
    accessModes:
      - ReadWriteOnce
      - ReadWriteMany
    nfs:
      server: 192.168.1.100
      path: /opt/persistence/storage4
    persistentVolumeReclaimPolicy: Recycle
- apiVersion: v1
  kind: PersistentVolume
  metadata:
    name: storage5
  spec:
    capacity:
      storage: 5Gi
    accessModes:
      - ReadWriteOnce
      - ReadWriteMany
    nfs:
      server: 192.168.1.100
      path: /opt/persistence/storage5
    persistentVolumeReclaimPolicy: Recycle
- apiVersion: v1
  kind: PersistentVolume
  metadata:
    name: storage6
  spec:
    capacity:
      storage: 5Gi
    accessModes:
      - ReadWriteOnce
      - ReadWriteMany
    nfs:
      server: 192.168.1.100
      path: /opt/persistence/storage6
    persistentVolumeReclaimPolicy: Recycle
- apiVersion: v1
  kind: PersistentVolume
  metadata:
    name: storage7
  spec:
    capacity:
      storage: 5Gi
    accessModes:
      - ReadWriteOnce
      - ReadWriteMany
    nfs:
      server: 192.168.1.100
      path: /opt/persistence/storage7
    persistentVolumeReclaimPolicy: Recycle
- apiVersion: v1
  kind: PersistentVolume
  metadata:
    name: storage8
  spec:
    capacity:
      storage: 5Gi
    accessModes:
      - ReadWriteOnce
      - ReadWriteMany
    nfs:
      server: 192.168.1.100
      path: /opt/persistence/storage8
    persistentVolumeReclaimPolicy: Recycle
- apiVersion: v1
  kind: PersistentVolume
  metadata:
    name: storage9
  spec:
    capacity:
      storage: 5Gi
    accessModes:
      - ReadWriteOnce
      - ReadWriteMany
    nfs:
      server: 192.168.1.100
      path: /opt/persistence/storage9
    persistentVolumeReclaimPolicy: Recycle
- apiVersion: v1
  kind: PersistentVolume
  metadata:
    name: storage10
  spec:
    capacity:
      storage: 5Gi
    accessModes:
      - ReadWriteOnce
      - ReadWriteMany
    nfs:
      server: 192.168.1.100
      path: /opt/persistence/storage10
    persistentVolumeReclaimPolicy: Recycle
EOF
