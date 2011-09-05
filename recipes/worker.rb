#
# Cookbook Name:: hadoop
# Recipe:: worker
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

package "hadoop-0.20-tasktracker" do
  action :install
end

service "hadoop-0.20-tasktracker" do
  action [:nothing]
  supports :restart => true, :start => true, :stop => true
end

package "hadoop-0.20-datanode" do
  action :install
end

service "hadoop-0.20-datanode" do
  action [:nothing]
  supports :restart => true, :start => true, :stop => true
end

# ssh config - hadoop user has to get around the cluster

# necessary conf files

# core-site.xml

# hdfs-site.xml

# mapred-site.xml


