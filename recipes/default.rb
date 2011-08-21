#
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

when "centos", "redhat"

  execute "yum_clean_all" do
    command "yum clean all"
    action :nothing
  end

  execute "import_key_rhel5" do
    command "rpm --import http://archive.cloudera.com/redhat/cdh/RPM-GPG-KEY-cloudera"
    action :nothing
  end

  execute "import_key_rhel6" do
    command "rpm --import http://archive.cloudera.com/redhat/6/x86_64/cdh/RPM-GPG-KEY-cloudera"
    action :nothing
  end

  # find the platform version number. support 5 and 6
  version = node['platform_version'].to_i
  Chef::Log.info("the platform_version is #{version}")

  # version 5
  if version == 5 
    # repo file
    cookbook_file "/etc/yum.repos.d/cloudera-cdh3.repo" do
      source "cloudera_rhel5.repo"
      mode 0644
      owner "root"
      group "root"
      notifies :run, "execute[yum_clean_al]", :immediately
      notifies :run, "execute[import_key_rhel5]", :immediately
    end
  end

  # version 6
  if version == 6
    # repo file
    cookbook_file "/etc/yum.repos.d/cloudera-cdh3.repo" do
      source "cloudera_rhel6.repo"
      mode 0644
      owner "root"
      group "root"
      notifies :run, "execute[yum_clean_all]", :immediately
      notifies :run, "execute[import_key_rhel6]", :immediately
    end
  end

  package "hadoop-0.20" do
    action :install
  end
end


#package "hadoop"

