![](media/image1.png)

Deployment How-to Microsoft Azure Dev/Test

<span id="_Toc418611311" class="anchor"><span id="_Toc418618601"
class="anchor"></span></span>

Date: 2015-09-18

Version: 1.2

Authors: Risto Lavett

> <risto.lavett@redeploy.se>
>
> +46-735-242413

Table of content

1\. Introduction 3

2\. Administration 3

2.1. Subscription 3

2.2. Account 3

2.3. Portal 3

2.4. Powershell 3

2.5. Deployment Template 3

2.6. Remote Desktop 3

3\. Name Standard 4

3.1. Customer 4

3.2. Environment 4

3.3. Function 4

3.4. Number 4

3.5. Type 4

4\. Architecture 4

4.1. Resource Group ![](media/image2.png) 4

4.2. Storage Account ![](media/image3.png) 4

4.3. Virtual Network ![](media/image4.png) 4

4.4. Subnet ![](media/image5.png) 5

4.5. Network Interface ![](media/image6.png) 5

4.6. Public IP Address ![](media/image7.png) 5

4.7. Network Security Group ![](media/image8.png) 5

4.8. Virtual Machine ![](media/image9.png) 5

5\. Deployment 6

5.1. Deployment through Template 6

5.2. Deployment without template 9

Introduction
============

Microsoft Azure is a cloud platform with IaaS (Infrastructure as a
Service), PaaS (Platform as a Service) and SaaS (Software as a Service)
services. PocketMobile has a MSDN Dev/Test environment which mainly
consists of IaaS services to serve as development and test for their
applications. There are rules on how-to setup and deploy services under
the subscription which is described in this document. This document is
for internal use only and should not be shared outside of the company
without explicit approval from management.

Jump directly to [*Administration*](#_Administration_1).

Jump directly to [*Name Standard*](#_Name_Standard).

Jump directly to [*Architecture*](#_Architecture).

Jump directly to [*Deployment*](#_Deployment).

<span id="_Administration" class="anchor"><span id="_Administration_1" class="anchor"><span id="_Toc430343020" class="anchor"></span></span></span>Administration
=================================================================================================================================================================

The following section describes how to access the Azure services.

Subscription
------------

The main framework of everything is the subscription which all the
services belong to. This is managed by the admin and co-admins. A
regular user gets access by an admin or co-admin to access the
subscription or services part of the subscription. A regular user
doesn’t need to worry about managing the subscription.

Account
-------

To get access to the services the user need a Microsoft enabled email.
Once the email is MS registered, access to the subscription or correct
group should be requested from the admin or co-admin.

Portal
------

There are two web interfaces the “old” and the “new” one. The new one is
going to replace the old one in time, but for now some resources and
management for example Active Directory administration must be done
through the old portal.

The web interface for the old portal is
[*http://manage.windowsazure.com*](http://manage.windowsazure.com)

The web interface for the new portal is
[*http://portal.azure.com*](http://portal.azure.com)

Powershell
----------

The script interface for all management is PowerShell with the azure
module which can be downloaded here:
[*http://go.microsoft.com/fwlink/p/?linkid=320376&clcid=0x41d*](http://go.microsoft.com/fwlink/p/?linkid=320376&clcid=0x41d)
*.*

How to use PowerShell will not be described in this document.

Deployment Template
-------------------

To simplify deployment there is a pre made deployment template here:
[*https://bitbucket.org/redeploy/windows*](https://bitbucket.org/redeploy/windows)

More information on how to [*Deploy*](#_Deployment_1).

Remote Desktop
--------------

All virtual machines can be accessed directly with RDP on the standard
port and the DNS name which is created during deployment.

Name Standard
=============

The following section describes the name standard for PocketMobile
Dev/Test services in the Azure cloud. The Virtual Machine standard is
&lt;Customer&gt;&lt;Environment&gt;&lt;Function&gt;&lt;Number&gt; and
will be named for example consosdevapp01. Below are the name standard
sections.

For specific name standard rules on the resources see
[*Architecture*](#_Architecture_1).

Customer
--------

Name of customer in six (lowercase) letter abbreviation, example schenk,
pmcswe, consos and so forth.

Environment
-----------

Type of environment in two to three (lowercase) letter abbreviation,
example dev, qa, tst, lab.

Function
--------

Type of server in two or three (lowercase) letter abbreviation, example
app, db, web and srv.

Number
------

Instance number of the Virtual Machine, example 01, 02, 03.

Type
----

Type of service in two or three (lowercase) letter abbreviation, example
stg, rg, pip.

<span id="_Architecture" class="anchor"><span id="_Architecture_1" class="anchor"><span id="_Toc430343033" class="anchor"></span></span></span>Architecture
===========================================================================================================================================================

<span id="_Toc418611318" class="anchor"></span>The following section
describes the infrastructure and dependencies of the Azure services and
what services a common setup consists of for PocketMobile.

Resource Group ![](media/image2.png) 
-------------------------------------

The main container for all Azure services is the Resource Group. All
below services are members of a Resource Group.

The name standard is &lt;Customer&gt;&lt;Environment&gt;&lt;rg&gt;

for example contosdevrg.

Storage Account ![](media/image3.png)
-------------------------------------

The Storage Account is the container for all storage, this means the OS
disk and extra disk attached to the Virtual Machines. As well as
logging, debugging and monitoring data. There is a Storage Account
created per Virtual Machine.

The name standard is
&lt;Customer&gt;&lt;Environment&gt;&lt;Function&gt;&lt;Number&gt;&lt;sa&gt;

for example contosdevapp01sa.

Virtual Network ![](media/image4.png)
-------------------------------------

The Virtual Network is the parent for the subnets. There can only be one
Virtual Network per Resource Group.

The name standard is &lt;Customer&gt;&lt;Environment&gt;&lt;net&gt;

for example contosdevnet.

Subnet ![](media/image5.png)
----------------------------

The Subnet is a divided section of the Virtual Network and consists of
Virtual Machines in the proper subnet. For example, an app server is in
the app Subnet, a db server is in the db subnet and so forth. All
Subnets in the same Virtual Network can communicate on all protocols and
port with each other.

The name standard is
&lt;Customer&gt;&lt;Environment&gt;&lt;Function&gt;&lt;sub&gt;

for example contosdevappsub.

Network Interface ![](media/image6.png)
---------------------------------------

The Network Interface is a virtual NIC. Each Virtual Machine must have
at least one Network Interface with a parent Public IP Address.

The name standard is
&lt;Customer&gt;&lt;Environment&gt;&lt;Function&gt;&lt;Number&gt;&lt;nic&gt;

for example contosdevapp01nic.

Public IP Address ![](media/image7.png)
---------------------------------------

Each Network Interface has a Public IP Address which is presented to
Internet and have a DNS name.

The name standard is
&lt;Customer&gt;&lt;Environment&gt;&lt;Function&gt;&lt;Number&gt;&lt;pip&gt;

for example contosdevapp01pip.

Network Security Group ![](media/image8.png)
--------------------------------------------

A Network Security Group controls the protocols and ports for either the
Virtual Machine and/or Subnet. It is the Virtual Firewall for the
Servers. You can have one Network Security group per Subnet and co-exist
with a Security group for the Virtual Machine.

The name standard is
&lt;Customer&gt;&lt;Environment&gt;&lt;Function&gt;&lt;nsg&gt;

for example contosdevappnsg.

Virtual Machine ![](media/image9.png)
-------------------------------------

The Virtual Machine is server compute capacity and are using predefined
sizes. For example, Standard\_D1 (1 CPU core, 3.5GB RAM, 50GB SSD disk)
or Standard\_D2 (2 CPU core, 7GB RAM, 100GB SSD disk).

The name standard is
&lt;Customer&gt;&lt;Environment&gt;&lt;Function&gt;&lt;Number&gt; for
example contosdevapp01.

<span id="_Name_Standard" class="anchor"><span id="_Deployment" class="anchor"><span id="_Deployment_1" class="anchor"><span id="_Toc422077906" class="anchor"><span id="_Toc430343042" class="anchor"></span></span></span></span></span>Deployment 
=====================================================================================================================================================================================================================================================

The following section describes how-to deploy services from scratch as
well adding Virtual Machines to an existing Service Group.

Deployment through Template
---------------------------

Make sure you have got access to the Subscription from your
administrator.

Browse to
[*https://bitbucket.org/redeploy/windows*](https://bitbucket.org/redeploy/windows)

![](media/image10.png)

Click the ”Deploy to Azure” button.

![](media/image11.png)

Log in with your MS account.

### 

![](media/image12.png)You should now land on the custom deployment page
with the “Edit parameters” active.

![](media/image13.png)

Enter the customer name of the environment. Must be six characters long
and only lowercase letters.

![](media/image14.png)

Enter the Environment Type by using one of the selections in the
dropdown menu.

![](media/image15.png)

Enter the Server Type of the Virtual Machine by using the dropdown menu.

![](media/image16.png)

Enter the Server Number of the Virtual Machine by using the dropdown
menu.

![](media/image17.png)

Enter the Admin User of the Virtual Machine by using the dropdown menu.

![](media/image18.png)Enter the Admin User Password of the Virtual
Machine. Must be at least 8 characters and have at least one capital
letter, one number and one special character.

![](media/image19.png)

Enter the Windows OS of the Virtual Machine by using the dropdown menu.

![](media/image20.png)

Enter the Server Size of the Virtual Machine by using the dropdown menu.
Standard\_D1 equals 1 CPU core, 3.5GB RAM, 50GB SSD disk. Standard\_D2
equals 2 CPU core, 7GB RAM, 100GB SSD disk.

<span id="_Toc418611327" class="anchor"><span id="_Toc418618613"
class="anchor"><span id="_Toc422077909"
class="anchor"></span></span></span>![](media/image21.png)

Select “PocketMobile MSDN DevTest” subscription and proceed.

![](media/image22.png)

If this is an existing environment which you are adding servers to,
select the corresponding Resource Group. If this is a new environment,
select “Or create new”.

![](media/image23.png)If you selected “Or create new” enter the name of
the Resource Group according to the name standard explained earlier.

![](media/image24.png)

Resource Group location should be “West Europe” by default. This should
always be selected if nothing else is communicated.

![](media/image25.png)

Click on “Legal terms”.

![](media/image26.png)

Scroll down and click on “Buy”.

![](media/image27.png)

Click on “Create”. The deployment process will now start!

![](media/image28.png)

The Deployment process is now underway and you can monitor it by
clicking “Notifications” on the start page.

![](media/image29.png)

Click on “Audit logs”.

![](media/image30.png)Here you can see all operations underway and also
the result. If you click on a specific operation you will get more
information which is good for troubleshooting if something goes wrong.

![](media/image31.png)If all goes well, you can click on “Browse all”
and there you will see all resources.

![](media/image32.png)

Click on the Virtual Machine. From the window you can directly connect
through RDP on the “Connect” selection. You are now ready to start
working!

Deployment without template
---------------------------

Make sure you have got access to the Subscription from your
administrator.

Browse to [*https://portal.azure.com*](https://portal.azure.com)

![](media/image11.png)

Log in with your MS account.

![](media/image33.png)Click on “New”.

![](media/image34.png)Click on “Compute”

Click on “Marketplace”

And search for the specific OS or Image you want do deploy from.

![](media/image35.png)

Select the Image you want to deploy from.

![](media/image36.png)

Select “Resource Manager” (This is important) and click “Create”.

![](media/image37.png)

Enter the name of the Virtual Machine according to the name standard
explained earlier.

![](media/image38.png)

Enter the Admin User of the Virtual Machine.

Enter the Admin User Password of the Virtual Machine. Must be at least 8
characters and have at least one capital letter, one number and one
special character.

![](media/image21.png)

The Subscription should be correct by default. If there are several
subscriptions select “PocketMobile MSDN DevTest” and proceed.

![](media/image39.png)If this is an existing environment which you are
adding servers to, select the corresponding Resource Group.

![](media/image40.png)If this is a new environment, enter the name of
the new Resource Group according to the name standard explained earlier.

![](media/image41.png)Location should be “West Europe”.

Click “OK”.

![](media/image42.png)Click “View all” and select the size of your
Virtual Machine.

![](media/image43.png)

If this is an existing environment which you are adding servers to,
select the corresponding Storage Account.

If this is a new environment, enter the name of the new Storage Account
according to the name standard explained earlier.

![](media/image44.png)

If this is an existing environment which you are adding servers to,
select the corresponding Virtual Network, Subnet, Public IP Address and
Network Security Group.

If this is a new environment, enter the name of the new Network Services
according to the name standard explained earlier.

![](media/image45.png)

Disable Monitoring if now explicitly needed.

![](media/image46.png)

Usually no redundancy is needed and therefore Availability Set is set to
none.

Click OK and proceed.

![](media/image47.png)Control the Summary to see everything looks good.
Double check the name standard.

Click “OK” and “Create” The deployment process will now start!

![](media/image28.png)

The Deployment process is now underway and you can monitor it by
clicking “Notifications” on the start page.

![](media/image29.png)

Click on “Audit logs”.

![](media/image30.png)Here you can see all operations underway and also
the result. If you click on a specific operation you will get more
information which is good for troubleshooting if something goes wrong.

![](media/image48.png)

If all goes well, you can click on “Browse all” and there you will see
all resources.

![](media/image49.png)Click on the Virtual Machine. From the window you
can directly connect through RDP on the “Connect” selection. You are now
ready to start working!
