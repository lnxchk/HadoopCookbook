# Cookbook Name:: hadoop
# Recipe:: apache_hadoop
#
# Copyright 2009, Opscode, Inc.
# Copyright 2011, linuxchick.org
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

#
# sample recipe for using tars from apache instead of cloudera
# most likely usecase is as a replacement for the ::default recipe

include_recipe "java"
#include_recipe "hadoop::hadoop_user"

# 1. set the mirror url based on proximity
#    http://www.apache.org/dyn/closer.cgi/hadoop/core/

mirror_url = "http://www.trieuvan.com/apache/hadoop/common/stable"

# this is the version number that the tar ball unwraps do
hadoop_version = "hadoop-0.20.203.0"

# this is essentially the version, but as it is annotated in the filenames
hadoop_filename = "hadoop-0.20.203.0rc1"

hadoop_url = "#{mirror_url}/#{hadoop_filename}.tar.gz"
checksum_url = "#{mirror_url}/#{hadoop_filename}.tar.gz.mds"

# 2. pull the file itself into /tmp or something

remote_file "/tmp/#{hadoop_filename}.tar.gz" do
  source hadoop_url
  mode 0644
end

  
# 3. download a checksum

remote_file "/tmp/#{hadoop_filename}.tar.gz.mds" do
  source checksum_url
  mode 0644
end

# 4. run checksum, fail out if fail
#    gpg --print-mds hadoop-0.20.203.0rc1.tar.gz

bash "check download" do
  cwd "/tmp"
  code <<-EOH
    gpg --print-mds hadoop-0.20.203.0rc1.tar.gz > new.mds
    diff #{hadoop_filename}.tar.gz.mds new.mds
    # TODO want to test $?
  EOH
  not_if { File.exists?("/usr/lib/#{hadoop_version}") }
end
# 5. untar the download into some dir, assuming /usr/lib/ now

bash "install apache_hadoop" do
  cwd "/usr/lib"
  code <<-EOH
  tar zxf /tmp/#{hadoop_filename}.tar.gz
  ln -s #{hadoop_version} hadoop
  EOH
  not_if { File.exists?("/usr/lib/hadoop") }
end

include_recipe "hadoop::hadoop_user"

bash "chown to hadoop" do
  cwd "/usr/lib"

  code <<-EOH
    chown -R hadoop:hadoop hadoop*
  EOH
end
  


# fin
