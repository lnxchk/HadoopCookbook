# Hadoop Cookbook

This cookbook is a work in progress.  It's essentially the second version I've put together, after learning a bit about what sorts of bad assumptions I was making with our clusters and how they had been set up.  I still have some things on my radar, like monitoring and quotas on the datanodes.

The changes I've made here are exclusively for rpm-based systems.  I plan to offer these changes to the maintainer of the HadoopCluster cookbook to expand that cookbook, since it currently only supports debian and ubuntu, and simply roll them together. I haven't worked off that version since it's significantly different from the environment I've been working on this in.

The templates are not exhaustively complete config files, but I have included links to the hadoop documentation for all options.  From a functional standpoint, the main components are here, and would hopefully only require minor changes to get running in any given environment.

I've tried to keep the recipes clean from the standpoint of being able to run multiple clusters with this same cookbook, setting up the attributes necessary for new clusters.  I do have a ToDo to look at cleaning that part up and using the environments in a smarter way or potentially putting things in a databag.

I have my own list of open issues in github for this project.  Feel free to comment, add new ones, close, or whatever.

Some additional points:

* this makes a mess of the existing Debian / Ubuntu stuff in the current community cookbook. the HadoopCluster cookbook is similar to this one and only supports Debian and Ubuntu.

* includes support for RHEL and CentOS.  Any other RPM-based platform could be added, I just don't have the version numbers for what would work with the current hadoop releases.

* sets up hadoop based on the ops suggestions in "Hadoop The Definitive Guide" by Tom White (ISBN: 978-1-449-38973-4) and what we're doing at Admeld

* includes several specific recipes for explicit resource management

## Default recipe

* requires the java and yum cookbooks

* sets up the dependencies for the Cloudera RPM repository, the .repo file and the RPM keys

* installs the base hadoop package, assuming hadoop-0.20

## Apache_hadoop recipe

* pulls the tar files from apaches repo, rather than prebuilt rpms.  uses /usr/lib/hadoop as the location of the install to correspond with the cloudera rpms, but that could be changed.

* This doesn't include start scripts or anything really fancy. I just added it as an alternative to the cloudera packages. If you choose to use it, read through the recipe and change things like the mirror you're using and the file versions.

## Namenode recipe

* installs the namenode and secondarynamenode packages

* runs a couple of templated files out with settings in the attributes right now

## Jobtracker recipe

* installs the jobtracker package


## Worker recipe

* installs the tasktracker and datanode packages, as hadoop datanodes should always also be task nodes


## Hadoop_user recipe

* creates a hadoop user to own the files, hold the ssh keys for communicating in the cluster, and run the java processes

* cloudera's packages also use a mapred user and a hdfs user. they are installed with the rpms, but their responsibilities are set in /etc/default/hadoop-0.20.  For this version, I've replaced them to streamline the permissions on all of the directories.

## work to do

* potentially set up the services so they can be called by chef runs when config files change. not sure i would necessarily make use of it that way for the namenode and secondarynamenode.  The tasktracker and datanode processes should be ok to do that with though.

* potentially add a data bag to allow for locking down of the specific hadoop version, or otherwise rework how the attributes are set up. jtimberman recommends looking at the aws cookbook, specifically the ebs_volume stuff

* dealing with the ssh keys for the hadoop user.  there is some skeleton code there in the user recipe now.

* debian / ubuntu WAT.  see note above. 
