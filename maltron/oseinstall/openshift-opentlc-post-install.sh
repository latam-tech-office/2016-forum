oadm registry --replicas=1 --selector='host=infra' --config=/etc/origin/master/admin.kubeconfig --service-account=registry --images='registry.access.redhat.com/openshift3/ose-${component}:${version}'
oadm router default-router --stats-password='maltron' --replicas=1 --service-account=router --selector='host=infra' --credentials=/etc/origin/master/openshift-router.kubeconfig --images='registry.access.redhat.com/openshift3/ose-${component}:${version}'
cat << EOF > /etc/exports
/opt/storage/gogs/data    192.168.0.200 192.168.0.201(rw,sync,no_root_squash)
/opt/storage/gogs/mysql   192.168.0.200 192.168.0.201(rw,sync,no_root_squash)
/opt/storage/jenkins      192.168.0.200 192.168.0.201(rw,sync,no_root_squash)
/opt/storage/nexus        192.168.0.200 192.168.0.201(rw,sync,no_root_squash)
EOF
mkdir -p /opt/storage/gogs/data; chown -R nfsnobody:nfsnobody /opt/storage/gogs/data; chmod -R 777 /opt/storage/gogs/data
mkdir -p /opt/storage/gogs/mysql; chown -R nfsnobody:nfsnobody /opt/storage/gogs/mysql; chmod -R 777 /opt/storage/gogs/mysql
mkdir -p /opt/storage/jenkins; chown -R nfsnobody:nfsnobody /opt/storage/jenkins; chmod -R 777 /opt/storage/jenkins
mkdir -p /opt/storage/nexus; chown -R nfsnobody:nfsnobody /opt/storage/nexus; chmod -R 777 /opt/storage/nexus

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
      server: 192.168.0.100
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
      server: 192.168.0.100
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
      server: 192.168.0.100
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
      server: 192.168.0.100
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

oc create -n devops -f -<<EOF
apiVersion: v1
kind: List
items:
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
        - image: jenkinsci/jenkins:latest
          name: jenkins
          ports:
          - containerPort: 8080
            protocol: TCP
EOF

export GUID=`hostname|cut -f2 -d-|cut -f1 -d.`
export guid=`hostname|cut -f2 -d-|cut -f1 -d.`
HostIP=`host infranode00-$GUID.oslab.opentlc.com  ipa.opentlc.com |grep infranode | awk '{print $4}'`
domain="cloudapps-$GUID.oslab.opentlc.com"

oc volume deploymentConfig/gogs-mysql --add --name=storage-gogs-mysql --mount-path=/var/lib/mysql/data --claim-name=gogs-mysql --type=persistentVolumeClaim
oc expose deploymentConfig/gogs-mysql --port=3306
oc volume deploymentConfig/gogs --add --name=storage-gogs-data --mount-path=/data --claim-name=gogs-data --type=persistentVolumeClaim
oc expose deploymentConfig/gogs --port=3000
oc expose service/gogs --hostname=gogs.cloudapps-${GUID}.oslab.opentlc.com
oc volume deploymentConfig/nexus --add --name=storage-nexus --mount-path=/sonatype-work --claim-name=nexus --type=persistentVolumeClaim
oc expose deploymentConfig/nexus --port=8081
oc expose service/nexus --hostname=nexus.cloudapp-${GUID}.oslab.opentlc.coms
oc volume deploymentConfig/jenkins --add --name=storage-jenkins --mount-path=/var/jenkins_home --claim-name=jenkins --type=persistentVolumeClaim
oc expose deploymentConfig/jenkins --port=8080
oc expose service/jenkins --hostname=jenkins.cloudapp-${GUID}.oslab.opentlc.com

