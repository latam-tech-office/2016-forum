<h1><a href="https://www.gitbook.com/book/latam-tech-office/forumdemo">LATAM Red Hat Forum 2016 Demo</a></h1>
This is a demo shown during <a href="https://www.redhat.com/en/about/events">LATAM Red Hat Forum 2016</a> featuring several applications from Red Hat portfolio by delivering an ficticious Travel Agency scenario. Every application here runs in a container on top of <a href="https://docs.openshift.com/container-platform/3.4/welcome/index.html">OpenShift Container Platform</a> with minimum of 6 Nodes, all data will be persisted after reboots.<br/>

<h2><a href="https://www.gitbook.com/book/latam-tech-office/forumdemo">A detail instructions of how every application works, troubleshooting and more is available</a></h2>

After installation, you're going to get an environment with the following applications:
- <a href="https://www.redhat.com/en/technologies/management/cloudforms">Red Hat CloudForms</a>
- <a href="https://www.ansible.com/tower">Red Hat Ansible Tower</a>
- <a href="http://locust.io/">Locust</a>
- <a href="https://access.redhat.com/documentation/en-US/JBoss_Enterprise_BRMS_Platform/5/html/BRMS_Business_Process_Management_Guide/chap-Business_Central_Console.html">Red Hat Business Central</a>
- <a href="https://gogs.io/">Gogs</a>
- <a href="https://jenkins.io/">Jenkins</a>
- <a href="http://www.sonatype.org/nexus/">Nexus</a>
- Several Microservices written in Java, .NET, PHP
- <a href="https://www.redhat.com/en/technologies/mobile/application-platform">Red Hat Mobile Application Platform (aka RHMAP)</a>

## Before running the installer, please make sure
<h4><b>Note:</b> A installer called here it's a Ansible Playbook with a set of instructions based on a inventory file (hosts).</h4> 

1. You need a <a href="https://docs.openshift.com/container-platform/3.4/welcome/index.html">OpenShift Container Platform</a> (latest version possible) available at your disposal with *minimum* of 6 Nodes, with a user created named <b><i>'demo'</i></b>. (if you do want to use a different user, please look at step 9).

2. It's important that inside of yours <a href="https://docs.openshift.com/container-platform/3.4/welcome/index.html">OpenShift Container Platform</a> installation be able to resolve "cloudapps" domain.

    ```
    # nslookup testing.cloudapps.example.com
    Server:	8.8.8.8
    Address:	8.8.8.8#53

    Non-authoritative answer:
    Name:	terra.com.br
    Address: 208.84.244.112
    ```

    If that doesn't work, <a href="https://www.redhat.com/en/technologies/mobile/application-platform">RHMAP</a> will definitely fail. 

3. You need an active <a href="https://www.redhat.com/en/about/value-of-subscription">Red Hat Subscription</a> (ideally an Employee SKU) applied to all hosts which allows you to download all the necessary products.

4. You need to be <a href="https://docs.openshift.com/container-platform/3.4/welcome/index.html">OpenShift</a> System Administrator in order to run this installer.
    ```
    # oc login --username=system:admin
    Logged into "https://master.example.com:8443" as "system:admin" using existing credentials.
    ```

    The installer needs Administratives privileges in order to create and setup all the necessary permissions for each application.

5. You need some Persistence Volume (or PV) available at yours <a href="https://docs.openshift.com/container-platform/3.4/welcome/index.html">OpenShift's Cluster</a>:
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

    In case you don't have Persisent Volumes available at your <a href="https://docs.openshift.com/container-platform/3.4/welcome/index.html">OpenShift's Cluster</a>, we're providing another playbook that it will create some Persistent Volumes at your <a href="https://docs.openshift.com/container-platform/3.4/welcome/index.html">OpenShift's Master</a> using NFS. Again, you need root access at your host in order to be able to run this Ansible's playbook. Just type:

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

6. You need to download an <a href="https://www.ansible.com/tower">Ansible Tower</a> license and leave it at the same directory as the installer: <b>/2016-forum</b><br/>
   The file should look like: <b>license_b4451138a1234212ac8476cc756a08e9.txt</b>

7. You need to download 3 jar files needed by Business Central and copy then into the folder: <br/><b>/2016-forum/templates/rhcs-bc/installs/</b>

   File <a href="https://access.redhat.com/jbossnetwork/restricted/softwareDownload.html?softwareId=37383">jboss-eap-6.4.0-installer.jar</a>   
   <a href="https://access.redhat.com/jbossnetwork/restricted/softwareDownload.html?softwareId=37383">https://access.redhat.com/jbossnetwork/restricted/softwareDownload.html?softwareId=37383</a>

   File <a href="https://access.redhat.com/jbossnetwork/restricted/softwareDownload.html?softwareId=43071">jboss-eap-6.4.7-patch.zip</a>        
   <a href="https://access.redhat.com/jbossnetwork/restricted/softwareDownload.html?softwareId=43071">https://access.redhat.com/jbossnetwork/restricted/softwareDownload.html?softwareId=43071</a>

   File <a href="https://access.redhat.com/jbossnetwork/restricted/softwareDownload.html?softwareId=43631">jboss-brms-6.3.0.GA-installer.jar</a>         
   <a href="https://access.redhat.com/jbossnetwork/restricted/softwareDownload.html?softwareId=43631">https://access.redhat.com/jbossnetwork/restricted/softwareDownload.html?softwareId=43631</a>

8. Check the file <b>/2016-forum/hosts</b> and it should match all your hosts of your cluster. In this example, there is a <a href="https://docs.openshift.com/container-platform/3.4/welcome/index.html">OpenShift's Cluster</a> with 8 hosts named: <i>master.example.com, infra.example.com, node1.example.com, node2.example.com, node3.example.com, node4.example.com, node5.example.com and node6.example.com.</i>

    ```
    # cat hosts
    [openshift-hosts]
    master.example.com
    infra.example.com
    node[1:6].example.com
    ```

    Adjust this file accordingly.

9. Check the file <b>/2016-forum/group_vars/all</b> which contains most of the variables necessary to setup all applications. Modfied any information to suit your needs. For example, all applications will be installed for user 'demo'. If you want to be installed on a different user, change the property "username" on this file. 

   
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

<b>REMEMBER:</b> This installation provisions all the applications, creates all necessary projects inside <a href="https://docs.openshift.com/container-platform/3.4/welcome/index.html">OpenShift Container Platform</a> and setup all the data in each application. Hence, it might take approximately <u><b>50 minutes</b></u> to get it done. 

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

