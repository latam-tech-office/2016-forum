oc volume deploymentConfig/gogs-mysql --add --name=storage-gogs-mysql --mount-path=/var/lib/mysql/data --claim-name=gogs-mysql --type=persistentVolumeClaim
oc scale dc/gogs-mysql --replicas=1
oc volume deploymentConfig/gogs --add --name=storage-gogs-data --mount-path=/data --claim-name=gogs-data --type=persistentVolumeClaim
oc scale dc/gogs --replicas=1
oc volume deploymentConfig/nexus --add --name=storage-nexus --mount-path=/sonatype-work --claim-name=nexus --type=persistentVolumeClaim
oc scale dc/nexus --replicas=1
oc volume deploymentConfig/jenkins --add --name=storage-jenkins --mount-path=/var/jenkins_home --claim-name=jenkins --type=persistentVolumeClaim
oc scale dc/jenkins --replicas=1
