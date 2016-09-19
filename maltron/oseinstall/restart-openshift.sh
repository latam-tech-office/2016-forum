echo ">>> Restart atomic-openshift-master"
systemctl restart docker; systemctl restart atomic-openshift-node; systemctl restart atomic-openshift-master
echo ">>> Restart INFRA:atomic-openshift-node"
ssh infra.workshop.com "systemctl restart docker; systemctl restart atomic-openshift-node"
echo ">>> Restart NODE:atomic-openshift-node"
ssh node.workshop.com "systemctl restart docker; systemctl restart atomic-openshift-node"
