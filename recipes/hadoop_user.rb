#
# Cookbook Name:: hadoop
# Recipe:: hadoop_user
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

##
#
# optional recipe to create a hadoop user
#  * packages include mapred and hdfs users
#
##



# coincides with the group added by the packages
group "hadoop" do
  gid 496
end

# user
# there are mapred and hdfs users added by the packages
user "hadoop" do
  uid 10000
  gid "hadoop"
  home "/usr/lib/hadoop"
  shell "/bin/bash"
  comment "Hadoop User"
end

directory "/usr/lib/hadoop/.ssh" do
  mode 00700
  owner "hadoop"
  group "hadoop"
  action :create
  recursive true
end

execute "change ownership" do
  command "chown -R hadoop:hadoop /usr/lib/hadoop; chmod g+w /usr/lib/hadoop"
  action :run
end


#
# HADOOP USER KEYS
#
# if you want to manage the hadoop processes centrally from the 
# namenodes, the scripts available in ${HADOOP_HOME}/bin require
# the hadoop user to have ssh access to all boxes.

#cookbook_file "/usr/lib/hadoop/.ssh/id_rsa.pub" do
#  source "hadoop_pub_key"
#  mode 0400
#  owner "hadoop"
#  group "hadoop"
#end

#cookbook_file "/usr/lib/hadoop/.ssh/id_rsa" do
#  source "hadoop_priv_key"
#  mode 0400
#  owner "hadoop"
#  group "hadoop"
#end

Chef::Log.info("our env is #{node.chef_environment}")

# attributes based on environments. 
java_home = node[:hadoop][node.chef_environment][:java_home] || node[:hadoop][:_default][:java_home]

hadoop_home = node[:hadoop][node.chef_environment][:hadoop_home] || node[:hadoop][:_default][:hadoop_home]


template "/usr/lib/hadoop/.profile" do
  source "hadoop-profile.erb"
  owner "hadoop"
  group "hadoop"
  mode 00644
  variables(
    :java_home => java_home,
    :hadoop_home => hadoop_home
  )
end

