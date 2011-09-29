# Cookbook Name:: hadoop
# Recipe:: default
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

  #
  # use the attributes to lock in the hadoop version.
  # 
  # see README_attributes.md for more info
  #
  hadoop_version = node[:hadoop][node.chef_environment][:hadoop_version] || "0.20"

  Chef::Log.info("hadoop version is #{hadoop_version}")
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

  package "hadoop-#{hadoop_version}" do
    action :install
  end
end

include_recipe "hadoop::hadoop_user"
###
#
#  Templates
#
#  see README_templates.md for more info
#
###
Chef::Log.info("our env is #{node.chef_environment}")


# 
# each cluster using this cookbook should have its specific attributes set in the 
# attributes files.  Defaults are used if there are no attributes set for the
# node's current environment.
#
site_master = node[:hadoop][node.chef_environment][:site_master] || node[:hadoop][:_default][:site_master]
child_java_opts = node[:hadoop][node.chef_environment][:child_java_opts] || node[:hadoop][:_default][:child_java_opts]
map_tasks_max = node[:hadoop][node.chef_environment][:map_tasks_max] || node[:hadoop][:_default][:map_tasks_max]
reduce_tasks_max = node[:hadoop][node.chef_environment][:reduce_tasks_max] || node[:hadoop][:_default][:reduce_tasks_max]
java_home = node[:hadoop][node.chef_environment][:java_home] || node[:hadoop][:_default][:java_home]

template "/usr/lib/hadoop/conf/core-site.xml" do
  source "core-site_xml.erb"
  owner "hadoop"
  group "hadoop"
  mode 0644
  variables(
    :site_master => site_master
  )
end

template "/usr/lib/hadoop/conf/mapred-site.xml" do
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
end

template "/usr/lib/hadoop/conf/hdfs-site.xml" do
  source "hdfs-site_xml.erb"
  owner "hadoop"
  group "hadoop"
  mode 00644
end

template "/etc/default/hadoop-0.20" do
  source "etc_default_hadoop.erb"
  owner "root"
  group "root"
  mode 0644
  variables(
    :java_home => java_home
  )
end

execute "chown" do
  command "chown hadoop:hadoop ~hadoop; chown -R hadoop:hadoop ~hadoop/*"
  action :run
end


