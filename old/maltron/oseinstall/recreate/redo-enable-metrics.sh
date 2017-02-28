oc project openshift-infra
oc create -f - <<API
apiVersion: v1
kind: ServiceAccount
metadata:
  name: metrics-deployer
secrets:
- name: metrics-deployer
API
oadm policy add-role-to-user edit system:serviceaccount:openshift-infra:metrics-deployer
oadm policy add-cluster-role-to-user cluster-reader system:serviceaccount:openshift-infra:heapster
oc secrets new metrics-deployer nothing=/dev/null
#oc process -f metrics.yaml -v HAWKULAR_METRICS_HOSTNAME=hawkular-metrics.cloudapps.openshift.com,USE_PERSISTENT_STORAGE=false,IMAGE_PREFIX=openshift/origin-,IMAGE_VERSION=latest | oc create -n openshift-infra -f -
oc process -f metrics.yaml -v HAWKULAR_METRICS_HOSTNAME=hawkular-metrics.cloudapps.openshift.com,USE_PERSISTENT_STORAGE=false | oc create -n openshift-infra -f -
