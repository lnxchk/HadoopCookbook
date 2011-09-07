
# Cookbook Name:: hadoop
# Recipe:: default
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

include_recipe "java"


case node['platform']
when "ubuntu", "debian"
  execute "apt-get update" do
    action :nothing
  end

  template "/etc/apt/sources.list.d/cloudera.list" do
    owner "root"
    mode "0644"
    source "cloudera.list.erb"
    notifies :run, resources("execute[apt-get update]"), :immediately
  end

  execute "curl -s http://archive.cloudera.com/debian/archive.key | apt-key add -" do
    not_if "apt-key export 'Cloudera Apt Repository'"
  end
 
  package "hadoop"

when "centos", "redhat"

  # find the platform version number. support 5 and 6
  version = node['platform_version'].to_i
  Chef::Log.info("the platform_version is #{version}")

  # version 5
  if version == 5 
    key_url = "http://archive.cloudera.com/redhat/cdh/RPM-GPG-KEY-cloudera"
    mirror_url = "http://archive.cloudera.com/redhat/cdh/3/mirrors"
  end

  # version 6
  if version == 6
    key_url = "http://archive.cloudera.com/redhat/6/x86_64/cdh/RPM-GPG-KEY-cloudera"
    mirror_url = "http://archive.cloudera.com/redhat/6/x86_64/cdh/3/mirrors"
  end

  # yum repository stuff at https://github.com/opscode/cookbooks/tree/master/yum
    yum_key "RPM-GPG-KEY-cloudera" do
      url key_url
      action :add
    end

    yum_repository "cloudera-cdh3" do
      repo_name "cloudera-cdh3"
      description "Cloudera Distribution for Hadoop, Version 3"
      url mirror_url
      mirrorlist true
      action :add
    end

  package "hadoop-0.20" do
    action :install
  end
end

###
#
#  Templates
#
#  see README_templates.rdoc for more info
#
###

site_master = data_bag_item('hadoop', 'hadoop')["site_master"]
child_java_opts = data_bag_item('hadoop', 'hadoop')["child_java_opts"]
map_tasks_max = data_bag_item('hadoop', 'hadoop')["map_tasks_max"]
reduce_tasks_max = data_bag_item('hadoop', 'hadoop')["reduce_tasks_max"]


template "/usr/lib/hadoop/conf/core-site.xml" do
  source "core-site_xml.erb"
  owner "hadoop"
  group "hadoop"
  mode 0644
  variables(
    :site_master => site_master
  )
end

template "/opt/hadoop/conf/mapred-site.xml" do
  source "mapred-site_xml.erb"
  owner "hadoop"
  group "hadoop"
  mode 00644
  variables(
    :site_master => site_master,
    :child_java_opts => child_java_opts,
    :map_tasks_max => map_tasks_max,
    :reduce_tasks_max => reduce_tasks_max
  )
  # notifies
end

