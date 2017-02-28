Step #1: Make sure all your Openshift's hosts is registered using subscription manager
# subscription-manager status
+-------------------------------------------+
   System Status Details
+-------------------------------------------+
Overall Status: Current

This is important, because we're going to need to add some repositories for RHMAP



Step #2 Be sure to have a 'demo' user available in your OpenShift installation


Step #3: Be sure to provide some Persistent Volumes with the following configuration

Amount    Type
25Gb      RWO


A playbook is available to create some NFS Exports into the master and 


Step #4: Check the hosts file and update with the hosts available in your OpenShift installation

[openshift-hosts]
master.example.com
infra.example.com
node[1:4].example.com


Step #5: Check the file group_vars/all and change with all information needed for your installation

for example, if your OpenShift's Domain is "mydomain.com", then change the value accordingly:
openshift_domain: mydomain.com

Step #6: Some applications need some particular files in order to install. Be sure you've got the following files available and upload them the right directory:

Ansible Tower:
Ansible Tower's License file 

Business Center:


Step #7: (OPTIONAL) If want to have each product running in separate node, update the following variables in file group_vars/all such as:

# RHMAP will be run on Nodes 1 and 2
# oc label node/node1.example.com rhmap=core
# oc label node/node2.example.com rhmap=core

...and then, define into the variable:
selector_core: "rhmap=core"



At the end of your installation, you're going to have the following products installed:
. Red Hat CloudForms
. Red Hat Ansible Tower
. Red Hat Mobile Application Platform
. Red Hat Business Center
. Gogs
. Jenkins
. Nexus
. Locust 

Tags:
--tags check
Check if the user is OpenShift's System Administrator "system:admin" and verify if all the necessary 
-- tags install_rhmap
-- tags install_rhmap_core
-- tags install_rhmap_mbaas
-- tags install_cloudforms


Pending Tasks:

We tried really hard to provisioning and config all the necessary applications using each Application's API. Unfortunately, not all products has a full and rich API that enable us to config and add all the necessary information. Here are some pending tasks that you might need to add manually:

. Red Hat CloudForms
. Red Hat Mobile Application Platform






