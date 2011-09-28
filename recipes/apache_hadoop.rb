# Cookbook Name:: hadoop
# Recipe:: apache_hadoop
#
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

# 1. set the mirror url based on proximity
#    http://www.apache.org/dyn/closer.cgi/hadoop/core/

mirror_url = "http://www.trieuvan.com/apache/hadoop/common/stable"

# set this var as an attribute. may be helpful for geographically
# diverse clusters using same cookbook. uncomment this line:
# mirror_url = node[:hadoop][node.chef_environment][:mirror_url]

# this is the version number that the tar ball unwraps do
hadoop_version = "hadoop-0.20.203.0"

# set this var as an attribute, uncomment this line:
# hadoop_version = node[:hadoop][node.chef_environment][:hadoop_version]

# this is essentially the version, but as it is annotated in the filenames
hadoop_filename = "hadoop-0.20.203.0rc1"

# set this var as an attribute, uncomment this line:
# hadoop_filename = node[:hadoop][node.chef_environment][:hadoop_filename]

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
    gpg --print-mds #{hadoop_filename}.tar.gz > new.mds
    diff #{hadoop_filename}.tar.gz.mds new.mds
    # TODO want to test $?
    # if the diff exits 1, there is a problem, and we should exit
    # clean up temp file
    rm -f new.mds    
  EOH
  not_if { File.exists?("/usr/lib/#{hadoop_version}") }
end
# 5. untar the download into some dir, assuming /usr/lib/ now

bash "install apache_hadoop" do
  cwd "/usr/lib"
  code <<-EOH
  tar zxf /tmp/#{hadoop_filename}.tar.gz
  ln -s #{hadoop_version} hadoop
  # clean up the files in /tmp that we downloaded
  rm -f /tmp/#{hadoop_filename}.tar.gz
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
