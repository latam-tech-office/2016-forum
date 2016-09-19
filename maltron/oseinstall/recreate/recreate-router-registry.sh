oc project default
oadm registry --replicas=1 --service-account=registry --selector='host=infra' --config=/etc/origin/master/admin.kubeconfig --images='registry.access.redhat.com/openshift3/ose-${component}:${version}'

oadm router default-router --stats-password='maltron' --selector='host=infra' --replicas=1 --service-account=router --config=/etc/origin/master/admin.kubeconfig --images='registry.access.redhat.com/openshift3/ose-${component}:${version}'
