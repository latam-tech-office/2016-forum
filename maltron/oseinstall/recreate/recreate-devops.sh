oc delete all --all --namespace devops
oc delete pvc --all --namespace devops
oc delete pv --all
rm -rf /var/exports/storage
mkdir -p /var/exports/storage/one /var/exports/storage/two /var/exports/storage/three /var/exports/storage/four
chown -R nfsnobody:nfsnobody /var/exports/storage/one /var/exports/storage/two /var/exports/storage/three /var/exports/storage/four
chmod -R 777 /var/exports/storage/one /var/exports/storage/two /var/exports/storage/three /var/exports/storage/four
systemctl restart nfs-server rpcbind
oc create --namespace devops -f -<<EOF
apiVersion: v1
kind: List
items:
- apiVersion: v1
  kind: PersistentVolume
  metadata:
    name: pv-one
  spec:
    capacity:
      storage: 2Gi
    accessModes:
      - ReadWriteMany
    nfs:
      server: 192.168.1.100
      path: /var/exports/storage/one
    persistentVolumeReclaimPolicy: Recycle
- apiVersion: v1
  kind: PersistentVolume
  metadata:
    name: pv-two
  spec:
    capacity:
      storage: 2Gi
    accessModes:
      - ReadWriteMany
    nfs:
      server: 192.168.1.100
      path: /var/exports/storage/two
    persistentVolumeReclaimPolicy: Recycle
- apiVersion: v1
  kind: PersistentVolume
  metadata:
    name: pv-three
  spec:
    capacity:
      storage: 2Gi
    accessModes:
      - ReadWriteMany
    nfs:
      server: 192.168.1.100
      path: /var/exports/storage/three
    persistentVolumeReclaimPolicy: Recycle
- apiVersion: v1
  kind: PersistentVolume
  metadata:
    name: pv-four
  spec:
    capacity:
      storage: 2Gi
    accessModes:
      - ReadWriteMany
    nfs:
      server: 192.168.1.100
      path: /var/exports/storage/four
    persistentVolumeReclaimPolicy: Recycle
- apiVersion: v1
  kind: PersistentVolumeClaim
  metadata:
    name: pvc-gogs
  spec:
    accessModes:
      - ReadWriteMany
    resources:
      requests:
        storage: 2Gi
- apiVersion: v1
  kind: PersistentVolumeClaim
  metadata:
    name: pvc-mysql
  spec:
    accessModes:
      - ReadWriteMany
    resources:
      requests:
        storage: 2Gi
- apiVersion: v1
  kind: PersistentVolumeClaim
  metadata:
    name: pvc-nexus
  spec:
    accessModes:
      - ReadWriteMany
    resources:
      requests:
        storage: 2Gi
- apiVersion: v1
  kind: PersistentVolumeClaim
  metadata:
    name: pvc-jenkins
  spec:
    accessModes:
      - ReadWriteMany
    resources:
      requests:
        storage: 2Gi
- apiVersion: v1
  kind: DeploymentConfig
  metadata:
    name: gogs-mysql
    labels:
      name: gogs-mysql
  spec:
    replicas: 1
    selector:
      app: gogs-mysql
      deploymentconfig: gogs-mysql
    template:
      metadata:
        labels:
          app: gogs-mysql
          deploymentconfig: gogs-mysql
      spec:
        containers:
        - image: openshift/mysql-55-centos7
          name: gogs
          env:
            - name: MYSQL_ROOT_PASSWORD
              value: maltron
            - name: MYSQL_USER
              value: mauricio
            - name: MYSQL_PASSWORD
              value: maltron
            - name: MYSQL_DATABASE
              value: gogs
          ports:
          - containerPort: 3306
            protocol: TCP
- apiVersion: v1
  kind: DeploymentConfig
  metadata:
    name: gogs
    labels:
      name: gogs
  spec:
    replicas: 1
    selector:
      app: gogs
      deploymentconfig: gogs
    template:
      metadata:
        labels:
          app: gogs
          deploymentconfig: gogs
      spec:
        containers:
        - image: gogs/gogs:latest
          name: gogs
          ports:
          - containerPort: 3000
            protocol: TCP
          - containerPort: 22
            protocol: TCP
- apiVersion: v1
  kind: DeploymentConfig
  metadata:
    name: nexus
    labels:
      name: nexus
  spec:
    replicas: 1
    selector:
      app: nexus
      deploymentconfig: nexus
    template:
      metadata:
        labels:
          app: nexus
          deploymentconfig: nexus
      spec:
        containers:
        - image: sonatype/nexus:2.12.0-01
          name: nexus
          ports:
          - containerPort: 8081
            protocol: TCP
- apiVersion: v1
  kind: DeploymentConfig
  metadata:
    name: jenkins
    labels:
      app: jenkins
  spec:
    replicas: 1
    selector:
      app: jenkins
      deploymentconfig: jenkins
    template:
      metadata:
        labels:
          app: jenkins
          deploymentconfig: jenkins
      spec:
        containers:
        - image: openshift3/jenkins-1-rhel7
          name: jenkins
          ports:
          - containerPort: 8080
            protocol: TCP
EOF

oc volume deploymentConfig/gogs-mysql --add --name=storage-mysql --mount-path=/var/lib/mysql/data --claim-name=pvc-mysql --type=persistentVolumeClaim -n devops
oc expose deploymentConfig/gogs-mysql --port=3306  -n devops
oc volume deploymentConfig/gogs --add --name=storagegogs --mount-path=/data --claim-name=pvc-gogs --type=persistentVolumeClaim  -n devops
oc expose deploymentConfig/gogs --port=3000 -n devops
oc expose service/gogs --hostname=gogs.cloudapps.workshop.com  -n devops
oc volume deploymentConfig/nexus --add --name=storagenexus --mount-path=/sonatype-work --claim-name=pvc-nexus --type=persistentVolumeClaim  -n devops
oc expose deploymentConfig/nexus --port=8081  -n devops
oc expose service/nexus --hostname=nexus.cloudapps.workshop.com  -n devops
oc volume deploymentConfig/jenkins --add --name=storagejenkins --mount-path=/var/jenkins_home --claim-name=pvc-jenkins --type=persistentVolumeClaim  -n devops
oc expose deploymentConfig/jenkins --port=8080  -n devops
oc expose service/jenkins --hostname=jenkins.cloudapps.workshop.com  -n devops

