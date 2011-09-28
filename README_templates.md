# Template Files

The configuration for hadoop allows for extensive customization and tuning of the cluster.  The attributes included
in this cookbook setup are really just a basic sample of the configurations available.

There are a number of configuration files available as well.  Only three are included in this version. Any value not explicitly 
set in the xml file will revert to the default as specified in the documentation.

## mapred-site.xml

The full documentation for this file is located at http://hadoop.apache.org/common/docs/current/mapred-default.html

The included variables are `site_master`, `child_java_opts`, `map_tasks_max`, and `reduce_tasks_max`.  

A permanent value for any of these variables can be set either in the recipe where the templates are evaluated or in the templates 
themselves. The environment-linked values are set in the attributes/default.rb file.

To change the values for a specific environment, add a new set of the required variables to the file. The recipes are
set to fail over to the values set for _default if there is no environment_specific value for that attribute.  The recipes
use `node.chef_environment` to determine which set of values to use.

Different variables can be added as needed by adding the config stanza to the xml file and updating the recipe.

## hdfs-site.xml

The current version of this cookbook includes no variables for the hdfs-site.xml file.  For full documentation of the options
available for hdfs, see http://hadoop.apache.org/common/docs/current/hdfs-default.html

## core-site.xml

The core-site.xml file sets up a number of global configurations for the cluster.  The site_master is the only variable currently
included, and is the namenode of the cluster.  

For full documentation of the options available for this file, see http://hadoop.apache.org/common/docs/current/core-default.html

