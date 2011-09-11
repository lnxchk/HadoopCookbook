# basic defaults:
default[:hadoop][:_default][:site_master]         = "ip-10-194-143-34.ec2.internal"
default[:hadoop][:_default][:child_java_opts]     = "-Xmx256M"
default[:hadoop][:_default][:map_tasks_max]       = "1"
default[:hadoop][:_default][:reduce_tasks_max]    = "1"    
default[:hadoop][:_default][:java_home]           = "/usr/lib/jvm/java-1.6.0"
default[:hadoop][:_default][:hadoop_home]         = "/usr/lib/hadoop"

# with an environment:
default[:hadoop][:bigmemboxes][:site_master]        = "somebigassbox"
default[:hadoop][:bigmemboxes][:child_java_opts]    = "-Xmx4096M"
default[:hadoop][:bigmemboxes][:map_tasks_max]      = "4"
default[:hadoop][:bigmemboxes][:reduce_tasks_max]   = "4"

