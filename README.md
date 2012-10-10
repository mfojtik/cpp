Deltacloud Control Panel
==============

About
-------------

This project is a demo application to show how easy is to build Deltacloud API
into your Rack application.

Basically, this project provide basic cloud account management, cloud account
sharing and detailed log views.

If you're in group where you need to share one or more cloud accounts with your
colleagues but you don't want to give them them the **real** API keys and
secret, this application can be handy.

How it works?
-------------

* User A create account.
* User A add one or more cloud accounts (eg. EC2, RHEV-M, OpenStack, etc.)
* User A make some of the cloud accounts 'public'

* User B create account.
* User B see the public cloud accounts User A created and user can use them.

* User B want to use EC2 account to get list of instances, User A created:

<code>$ curl --user 'userb:userbpassword' 'http://localhost:3000/api;driver=ec2/instances'</code>

* This application now authenticate the User B and substitute his credentials
with the 'real' cloud account credentials from the cloud account User A created.

* It does not matter what provider User B use, he always provide the same
credentials (his account credentials) and he have access to all cloud accounts.

* This application has Deltacloud API mounted to '/api', and you can use this
API as you can use the regular Deltacloud API.

How to install?
---------------

<code>$ git clone git://github.com/mifo/cpp.git</code>
<code>$ cd cpp && bundle</code>
<code>$ ./start</code>

When you first start this application, two users are created 'admin' and 'test'.
Both have password set to 'redhat'.
