<h1>LATAM Red Hat Forum 2016 Demo</h1>
This is demo shown during LATAM Red Hat Forum 2016 featuring several applications from Red Hat portfolio, bringing a some possible scenarios over a booking in Travel Agency. In order to get this application up-and-running, it's important that you have latest version of <a href="https://docs.openshift.com/container-platform/3.4/welcome/index.html">OpenShift Container Platform</a> with minimum of 6 Nodes and some Persistence Storage avaible [PENDING: Description of Persistence Storage].

## Before running the installer, please make sure
Note: A installer called here it's a Ansible Playbook with a set of instructions based on a inventory file (hosts). 

1. You need an OpenShift Container Platform (latest version possible) available at your disposal with *minimum* of 6 Nodes, with a user created named 'demo'. (if you do want to use a different user, please look at step 8).

2. You need an active Red Hat Subscription (ideally so called Employee SKU) applied to all hosts which allows you to download all the necessary products.

3. You need to be OpenShift's System Administrator in order to run this installer.
    ```
    # oc login --username=system:admin
    Logged into "https://master.example.com:8443" as "system:admin" using existing credentials.
    ```

The installer needs Administratives privileges in order to create and setup all the necessary permissions for each application.

4. You need som Persistence Volume (or PV) available at yours OpenShift's Cluster:
    ```
    # oc get pv
    NAME                  CAPACITY   ACCESSMODES   RECLAIMPOLICY   STATUS      CLAIM                                REASON    AGE
    local1-1g-tiny        1Gi        RWO,RWX       Recycle         Available                                                  2d
    local10-5g-small      5Gi        RWO,RWX       Recycle         Bound       rhmap-core/mysql                               2d
    local11-10g-regular   10Gi       RWO,RWX       Recycle         Available                                                  2d
    local12-10g-regular   10Gi       RWO,RWX       Recycle         Available                                                  2d
    local13-10g-regular   10Gi       RWO,RWX       Recycle         Available                                                  2d
    ...
    ..
    .
    ```

In case you don't have Persisent Volumes available at your OpenShift's Cluster, you're providing another playbook that it will create some Persistent Volumes at your OpenShift's Master using NFS. Again, you need root access to your host in order to be able to run this Ansible's playbook. Just type:

    ```
    # ./create_persistentvolumes.yaml
    PLAY [Setup a Persistence Volume (PV) on Server: 192.168.0.100 at /var/storage/local] ***

    TASK [setup] *******************************************************************
    ok: [localhost]

    TASK [Create directory for NFS Exports] ****************************************
    changed: [localhost] => (item={u'type': u'tiny', u'pv_size': 1, u'pv_index': 1})
    changed: [localhost] => (item={u'type': u'tiny', u'pv_size': 1, u'pv_index': 2})
    changed: [localhost] => (item={u'type': u'tiny', u'pv_size': 1, u'pv_index': 3})
    changed: [localhost] => (item={u'type': u'tiny', u'pv_size': 1, u'pv_index': 4})
    ...
    ..
    .

    ```

5. You need to download an <a href="https://www.ansible.com/tower">Ansible Tower</a> license and leave it at the same directory as the installer: /2016-forum
   The file should look like: license_b4451138a1234212ac8476cc756a08e9.txt

6. You need to download 3 jar files needed by Business Central and copy then into the folder: /2016-forum/templates/rhcs-bc/installs/
   The files are:

   File <a href="https://access.redhat.com/jbossnetwork/restricted/softwareDownload.html?softwareId=37383">jboss-eap-6.4.0-installer.jar</a>:   :  https://access.redhat.com/jbossnetwork/restricted/softwareDownload.html?softwareId=37383
   File <a href="https://access.redhat.com/jbossnetwork/restricted/softwareDownload.html?softwareId=43071">jboss-eap-6.4.7-patch.zip</a>        :  https://access.redhat.com/jbossnetwork/restricted/softwareDownload.html?softwareId=43071
   File <a href="https://access.redhat.com/jbossnetwork/restricted/softwareDownload.html?softwareId=43631">jboss-brms-6.3.0.GA-installer.jar</a>:  https://access.redhat.com/jbossnetwork/restricted/softwareDownload.html?softwareId=43631

7. Check the file /2016-forum/hosts and it should match all your hosts of your cluster. In this example, there is a OpenShift's Cluster with 8 hosts named: master.example.com, infra.example.com, node1.example.com, node2.example.com, node3.example.com, node4.example.com, node5.example.com and node6.example.com.

    ```
    # cat hosts
    [openshift-hosts]
    master.example.com
    infra.example.com
    node[1:6].example.com
    ```

    Adjust this file accordingly.

8. Check the file /2016-forum/group_vars/all which contains most of the variables necessary to setup all applications. Modfied any information to suit your needs. For example, all applications will be installed for user 'demo'. If you want to be installed on a different user, change the property "username" on this file. 

   
## When you've done all that

You're ready to run the installer by typing:
    ```
    # ./install.yaml
    PLAY [Check if all OpenShift's Hosts is registered using Red Hat's Subscription Manager] ***

    TASK [setup] *******************************************************************
    ok: [master.example.com]
    ok: [infra.example.com]
    ok: [node2.example.com]
    ...
    ..
    .

    ```

REMEMBER: This installation provisions all the applications, create all the necessary projects inside OpenShift Container Platform and setup all the data in each applicatin. Hence, it might take aproximadelly 50 minutes to get it done. 

There is a chance that some installation might fail. In that case, you might want to rerun the whole installer again, or you can always install each application individually. For example, let's suppose that I want to install just CloudForms and Ansible Tower:

    ```
    # ./install.yaml --tags cloudforms,tower
    PLAY [Check if all OpenShift's Hosts is registered using Red Hat's Subscription Manager] ***

    TASK [setup] *******************************************************************
    ok: [master.example.com]
    ok: [infra.example.com]
    ok: [node2.example.com]
    ...
    ..
    .

    ```

... and the equivalent to run the whole installer is:

    ```
    # ./install.yaml --tags cloudforms,tower,locust,tooling,business_central,microservices,rhmap
    PLAY [Check if all OpenShift's Hosts is registered using Red Hat's Subscription Manager] ***

    TASK [setup] *******************************************************************
    ok: [master.example.com]
    ok: [infra.example.com]
    ok: [node2.example.com]
    ...
    ..
    .

    ```








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
-- tags tower
-- tags cloudforms


Pending Tasks:

We tried really hard to provisioning and config all the necessary applications using each Application's API. Unfortunately, not all products has a full and rich API that enable us to config and add all the necessary information. Here are some pending tasks that you might need to add manually:

. Red Hat Ansible Tower
[PENDING: Robert]: Why does we need a forumadmin user inserted ? Can we just add demo user instead ?
[PENDING: Robert]: Why tower needs a root/password from OpenShift ? Can we just use demo user instead ?

. Red Hat CloudForms
. Red Hat Mobile Application Platform






