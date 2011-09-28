# Included Attributes

Attributes included in this revision include system values for the hadoop user's environment as well as some cluster settings.

Additional attributes can of course be added as needed by the site.

1. `site_master` : this is the namenode of the hadoop cluster, with a hostname or IP address that is addressable to the nodes
2. `child_java_opts` : any java settings that should be passed to the worker nodes when tasks are assigned.  The included example limits the amount of heap space granted to the processes
3. `map_tasks_max` : the number of concurrent map tasks that can be running on any given node
4. `reduce_tasks_max` : the number of concurrent reduce tasks that can be running on any given node
5. `java_home` : location of the preferred installation of java on the host. This setting is included in the hadoop user's .profile
6. `hadoop_home` : location of the hadoop installation on the host. This setting is included in the hadoop user's .profile. It could also be refactored into the recipes to change the location of hadoop system-wide in all the recipes.
7. `hadoop_version` : the release version of the hadoop software to install.  this version-locks all nodes in a particular environment to the same version and prevents unintended upgrades.

# Using the Attributes

The attributes in this cookbook are set up to rely on the value of node.chef_environment to determine their values.  Any hadoop cluster using this cookbook that has an assigned environment can have its own set of attribute values.  

Any values that are not set for the node's chef_environment will revert to the values set for the _default environment.

# Example

If this cookbook is being used for two clusters, different values can be assigned to the cluster attributes based on the environment names. 

If the clusters are assigned the environment names "finance" and "billing", separate values can be set as follows:

```
default[:hadoop][:finance][:site_master]         = "financemaster.example.com"
default[:hadoop][:finance][:child_java_opts]     = "-Xmx1024M"
default[:hadoop][:finance][:map_tasks_max]       = "2"
default[:hadoop][:finance][:reduce_tasks_max]    = "2"    
default[:hadoop][:finance][:java_home]           = "/usr/lib/jvm/java-1.6.0"
default[:hadoop][:finance][:hadoop_home]         = "/usr/lib/hadoop"
default[:hadoop][:finance][:hadoop_version]      = "0.20"

default[:hadoop][:billing][:site_master]         = "billingmaster.example.com"
default[:hadoop][:billing][:child_java_opts]     = "-Xmx2048M"
default[:hadoop][:billing][:map_tasks_max]       = "4"
default[:hadoop][:billing][:reduce_tasks_max]    = "4"    
default[:hadoop][:billing][:hadoop_version]      = "0.21"
```

In this example, the "finance" cluster sets all the attributes explicitly, localized the values to that environment.

The "billing" cluster does not explicitly set the `java_home`, `hadoop_home`, and `hadoop_version` attributes, so those values will revert to whatever is set for the _default environment in the `attributes/default.rb` file.
