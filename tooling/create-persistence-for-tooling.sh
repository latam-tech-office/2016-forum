oc create  -f -<<EOF
apiVersion: v1
kind: List
items:
- apiVersion: v1
  kind: PersistentVolumeClaim
  metadata:
    name: pvc-psql-gogs
  spec:
    accessModes:
      - ReadWriteOnce
      - ReadWriteMany
    resources:
      requests:
        storage: 5Gi
- apiVersion: v1
  kind: PersistentVolumeClaim
  metadata:
    name: pvc-psql-sonarqube
  spec:
    accessModes:
      - ReadWriteOnce
      - ReadWriteMany
    resources:
      requests:
        storage: 5Gi
- apiVersion: v1
  kind: PersistentVolumeClaim
  metadata:
    name: pvc-gogs-conf
  spec:
    accessModes:
      - ReadWriteOnce
      - ReadWriteMany
    resources:
      requests:
        storage: 5Gi
- apiVersion: v1
  kind: PersistentVolumeClaim
  metadata:
    name: pvc-gogs-repositories
  spec:
    accessModes:
      - ReadWriteOnce
      - ReadWriteMany
    resources:
      requests:
        storage: 5Gi		
- apiVersion: v1
  kind: PersistentVolumeClaim
  metadata:
    name: pvc-jenkins
  spec:
    accessModes:
      - ReadWriteOnce
      - ReadWriteMany
    resources:
      requests:
        storage: 5Gi
- apiVersion: v1
  kind: PersistentVolumeClaim
  metadata:
    name: pvc-nexus
  spec:
    accessModes:
      - ReadWriteOnce
      - ReadWriteMany
    resources:
      requests:
        storage: 5Gi
EOF
oc volume dc/gogs --name=gogs-conf --add --mount-path=/etc/gogs/conf --claim-name=pvc-gogs-conf
oc volume dc/gogs --name=gogs-repositories --add --mount-path=/home/gogs/gogs-repositories --claim-name=pvc-gogs-repositories
oc volume dc/nexus --name=nexus-data --add --mount-path=/nexus-data --claim-name=pvc-nexus
oc volume dc/jenkins --name=jenkins-data --add --mount-path=/var/lib/jenkins --claim-name=pvc-jenkins
oc volume dc/postgresql-gogs --name=storage-for-pgsql-gogs --add --mount-path=/var/lib/pgsql/data --claim-name=pvc-psql-gogs
oc volume dc/postgresql-sonarqube --name=storage-for-psql-sonarqube --mount-path=/var/lib/pgsql/data --claim-name=pvc-psql-sonarqube
