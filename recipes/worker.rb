#
# Cookbook Name:: hadoop
# Recipe:: worker
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

hadoop_version = node[:hadoop][node.chef_environment][:hadoop_version] || "0.20"

package "hadoop-#{hadoop_version}-tasktracker" do
  action :install
end

service "hadoop-#{hadoop_version}-tasktracker" do
  action [:nothing]
  supports :restart => true, :start => true, :stop => true
end

package "hadoop-#{hadoop_version}-datanode" do
  action :install
end

service "hadoop-#{hadoop_version}-datanode" do
  action [:nothing]
  supports :restart => true, :start => true, :stop => true
end

# for global hadoop config files, see the default recipe

# for advanced user set up, see the hadoop_user recipe

