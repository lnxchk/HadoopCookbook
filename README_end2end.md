
# hadoop distro version : cloudera or apache
  ## default recipe : cloudera rpms
  ## apache_hadoop recipe : apache tars

# check that the attributes values make sense

  ## add more for customization of templates if necessary in any given environment
  I put the site_master in the attributes right now really as a shortcut.  I think in actual practice I'll divide out the secondarynamenode into its own recipe, and then change the site_master to be defined as a search for a node running the namenode recipe in the appropriate chef_environment. but I haven't worked all the details out yet.

# set the environments for your nodes

# user management
  ## hadoop user
    I took this practice from the hadoop book, but cloudera's packages make some other assumptions about users.

  ## users included in the rpms
    can set the users in /etc/default/hadoop-0.20
    cloudera default includes the mapred and hdfs users
    this version simplified to one user for all hadoop things, the hadoop account
  ## JAVA_HOME for root 
    for starting the daemons
    not included in the scripts, so I have added it to /etc/default/hadoop-0.20 so the init scripts work

# create the namenode in chef
  ## namenode, secondarynamenode
  ## jobtracker

Technically, the namenode, secondarynamenode, and jobtracker can live on three different hosts.  The templates are set up such that the namenode and jobtracker would be the same system, but that should be easy to change.

# create the worker nodes
  ## worker recipe

# site-specific items for after the initial cookbook runs

# format the hdfs

This is in the hadoop docs, but i use `bin/hadoop namenode -format`.  I think I have all of the permissions issues ironed out with the tmp and cache directories that all the processes need, but there could be residual things that need tweaking, particularly with the cloudera-based stuff.


# give the hadoop user some ssh keys

These are only used if you want to manage the cluster centrally from the namenode or jobtracker node using the scripts in HADOOP_HOME/bin.

# make sure you can start and stop the cluster with the hadoop tools if you want to use them

# There aren't init scripts for the apache_hadoop things yet.

# fire up the processes on all nodes

I don't have this done via chef, because I'm not strong on automating the "only do this the first time" parts like formatting the hdfs. Workers, though, should be trivial to simply have the services start, I just haven't plugged that in yet. The cluster security stuff isn't enabled in these configurations by default, so any node that fires up and talks to the namenode will become part of the cluster.
