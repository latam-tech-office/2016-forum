oc scale dc/gogs --replicas=0
oc volume dc/gogs --name=storage-gogs-data --remove
oc scale dc/gogs-mysql --replicas=0
oc volume dc/gogs-mysql --name=storage-gogs-mysql --remove
oc scale dc/nexus --replicas=0
oc volume dc/nexus --name=storage-nexus --remove
oc scale dc/jenkins --replicas=0
oc volume dc/jenkins --name=storage-jenkins --remove
oc delete pvc --all -n devops
