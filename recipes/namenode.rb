#
# Cookbook Name:: hadoop
# Recipe:: namenode
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

include_recipe "hadoop::default"
hadoop_version = node[:hadoop][node.chef_environment][:hadoop_version]  || "0.20"

package "hadoop-#{hadoop_version}-namenode" do
  action :install
end

service "hadoop-#{hadoop_version}-namenode" do
  action [:nothing]
  supports :restart => true, :start => true, :stop => true
end

package "hadoop-#{hadoop_version}-secondarynamenode" do
  action :install
end

service "hadoop-#{hadoop_version}-secondarynamenode" do
  action [:nothing]
  supports :restart => true, :start => true, :stop => true
end

# masters file

key  = "recipe"
type = "node"
rec_query = "hadoop\\:\\:namenode"
env = node.chef_environment
Chef::Log.info("searching for #{type} #{key}:#{rec_query} in environment #{env}")

master_nodes = search(type.to_sym, "#{key}:#{rec_query} AND chef_environment:#{env}")
Chef::Log.info("the site masters are #{master_nodes}")

template "/usr/lib/hadoop/conf/masters" do
  source "masters.erb"
  owner "hadoop"
  group "hadoop"
  mode 0644
  variables(
    :masters => master_nodes
  )
end

# slaves file

node_query = "hadoop\\:\\:worker" 
Chef::Log.info("searching for #{type} #{key}:#{node_query} in environment #{env}")

slave_nodes = search(type.to_sym, "#{key}:#{node_query} AND chef_environment:#{env}")
Chef::Log.info("site slaves are #{slave_nodes}")

template "/usr/lib/hadoop/conf/slaves" do
  source "slaves.erb"
  owner "hadoop"
  group "hadoop"
  mode 0644
  variables(
    :slaves => slave_nodes
  )
end


