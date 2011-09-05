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
#  * packages include mapred and hdfs users,
#    but practice is usually to run all as
#    single hadoop account 
#
##

include_recipe "hadoop::default"

# coincides with the group added by the packages
group "hadoop" do
  gid 496
end

# user
# there are mapred and hdfs users added by the packages
user "hadoop" do
  uid 10000
  gid "hadoop"
  home "/usr/lib/hadoop-0.20"
  shell "/bin/bash"
  comment "Hadoop User"
end

directory "/usr/lib/hadoop-0.20/.ssh" do
  mode 00700
  owner "hadoop"
  group "hadoop"
  action :create
  recursive true
end

execute "change ownership" do
  command "chown -R hadoop:hadoop /usr/lib/hadoop-0.20"
  action :run
end

