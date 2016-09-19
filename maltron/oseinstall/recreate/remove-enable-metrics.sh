oc delete all --selector="metrics-infra" -n openshift-infra
oc delete sa --selector="metrics-infra" -n openshift-infra
oc delete templates --selector="metrics-infra" -n openshift-infra
oc delete secrets --selector="metrics-infra" -n openshift-infra
oc delete pvc --selector="metrics-infra" -n openshift-infra
oc delete sa metrics-deployer -n openshift-infra
oc delete secret metrics-deployer -n openshift-infra
