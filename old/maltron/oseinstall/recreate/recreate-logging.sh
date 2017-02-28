oadm new-project logging --node-selector="region=infra"
oc project logging
oc secrets new logging-deployer nothing=/dev/null
oc create -f - <<API
apiVersion: v1
kind: ServiceAccount
metadata:
  name: logging-deployer
secrets:
- name: logging-deployer
API
oc policy add-role-to-user edit --serviceaccount logging-deployer
oadm policy add-scc-to-user privileged system:serviceaccount:logging:aggregated-logging-fluentd 
oadm policy add-cluster-role-to-user cluster-reader system:serviceaccount:logging:aggregated-logging-fluentd
oc process -f /usr/share/openshift/examples/infrastructure-templates/enterprise/logging-deployer.yaml -v KIBANA_HOSTNAME=kibana.cloudapps.example.com,ES_CLUSTER_SIZE=1,PUBLIC_MASTER_URL=https://master.example.com:8443,IMAGE_PREFIX=registry.access.redhat.com/openshift3/,IMAGE_VERSION=3.2.0 | oc create -f -
