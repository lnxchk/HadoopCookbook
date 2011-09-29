# basic defaults:
default[:hadoop][:_default][:site_master]         = "domU-12-31-39-16-DA-B5"
default[:hadoop][:_default][:child_java_opts]     = "-Xmx256M"
default[:hadoop][:_default][:map_tasks_max]       = "1"
default[:hadoop][:_default][:reduce_tasks_max]    = "1"    
default[:hadoop][:_default][:java_home]           = "/usr/lib/jvm/java-1.6.0"
default[:hadoop][:_default][:hadoop_home]         = "/usr/lib/hadoop"
default[:hadoop][:_default][:hadoop_version]      = "0.20"

# with an environment:
default[:hadoop][:financecluster][:site_master]        = "somebigassbox"
default[:hadoop][:financecluster][:child_java_opts]    = "-Xmx4096M"
default[:hadoop][:financecluster][:map_tasks_max]      = "4"
default[:hadoop][:financecluster][:reduce_tasks_max]   = "4"

