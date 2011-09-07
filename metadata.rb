maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs hadoop and sets up basic cluster per Cloudera's quick start docs"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version           "0.9.0"
depends           "java"
depends           "yum"

recipe "hadoop", "Installs hadoop from Cloudera's repo"
recipe "hadoop::conf_pseudo", "Installs hadoop-conf-pseudo and enables hadoop services"
recipe "hadoop::doc", "Installs hadoop documentation"
recipe "hadoop::hive", "Installs hadoop's hive package"
recipe "hadoop::pig", "Installs hadoop's pig package"
recipe "hadoop::hadoop_user", "Creates a hadoop user. Optional if you're using other user management"
recipe "hadoop::jobtracker", "Install and initialize the jobtracker"
recipe "hadoop::namenode", "Install and initialize the namenode"
recipe "hadoop::worker", "Install and initialize tasktracker and datanode"

%w{ debian ubuntu redhat centos}.each do |os|
  supports os
end
