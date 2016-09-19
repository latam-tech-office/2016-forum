echo ">>> STATUS: Nodes"
oc get nodes
echo ">>> STATUS: FAILED SERVICES ????"
ssh node1.openshift.com "systemctl --failed"
echo ">>> STATUS: Router and Registry"
oc get pods -n default
echo ">>> STATUS: Metrics"
oc get pods -n openshift-infra
echo ">>> STATUS: FAILED SERVICES ????"
systemctl --failed
