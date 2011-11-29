Tomcat Cluster Scripts (tested on Mac OS X, Snow Leopard)
====================================

Heavily based on the work of Burt Beckwith and Peter Ledbrook, these scripts are designed to simplify deployment of a Grails application to a cluster production environment and to serve as a reference. Please see [Burt's blog post](http://burtbeckwith.com/blog/?p=244) and [Peter's posting on Tomcat Expert](http://www.tomcatexpert.com/blog/2010/07/20/basic-tomcat-clustering-grails-applications) for more background info. These scripts will work for any Java web framework that uses WAR files, not just Grails.

They use Tomcat 6.0.28 and its DeltaManager to handle session replication.

I have added the following to these scripts:

* When using the deploy script, you can specify a "context" in the environment variable CC. Without the CC variable it defaults to "ROOT".
* I've lengthened the time that catalina.sh waits for the apps to shutdown to 15 seconds.
* I've fixed the way that the run.sh script checks to see if a process has stopped. It was broken on Mac OS X (Snow Leopard).