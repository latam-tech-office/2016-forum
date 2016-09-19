oc project openshift-infra
oc create -n openshift-infra -f - <<API
apiVersion: v1
kind: ServiceAccount
metadata:
  name: metrics-deployer
secrets:
- name: metrics-deployer
API
oadm policy add-role-to-user edit system:serviceaccount:openshift-infra:metrics-deployer
oadm policy add-cluster-role-to-user cluster-reader system:serviceaccount:openshift-infra:heapster
oc secrets new metrics-deployer nothing=/dev/null -n openshift-infra
oc new-app -f metrics-deployer.yaml \
    -p HAWKULAR_METRICS_HOSTNAME=hawkular-metrics.cloudapps.forum.rhtechofficelatam.com \
    -p USE_PERSISTENT_STORAGE=false -p IMAGE_VERSION=3.2.1 -n openshift-infra
