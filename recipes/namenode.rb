#
# Cookbook Name:: hadoop
# Recipe:: namenode
#
# Copyright 2009, Opscode, Inc.
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

package "hadoop-0.20-namenode" do
  action :install
end

service "hadoop-0.20-namenode" do
  action [:nothing]
  supports :restart => true, :start => true, :stop => true
end

package "hadoop-0.20-secondarynamenode" do
  action :install
end

service "hadoop-0.20-secondarynamenode" do
  action [:nothing]
  supports :restart => true, :start => true, :stop => true
end

# masters file

key  = "recipe"
type = "node"
node_query = "hadoop\\:\\:namenode"
Chef::Log.info("searching for #{type} #{key}:#{node_query}")

master_nodes = search(type.to_sym, "#{key}:#{node_query}")
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
Chef::Log.info("searching for #{type} #{key}:#{node_query}")

slave_nodes = search(type.to_sym, "#{key}:#{node_query}")
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


