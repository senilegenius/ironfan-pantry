#
# Cookbook Name::       flume
# Description::         Finalizes the config, writes out the config files
# Recipe::              config_files
# Author::              Philip (flip) Kromer - Infochimps, Inc
#
# Copyright 2011, Infochimps, Inc.
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

# :hadoop, :hbase, :zookeeper, :jruby
[:flume].each do |component|
  next if node[component].nil? || node[component].empty?
  Chef::Log.info( [ component, node[component][:exported_jars] ].inspect )
  [node[component][:exported_jars]].flatten.compact.each do |export|
    link "#{node[:flume][:home_dir]}/lib/#{File.basename(export)}" do
      to  export
    end
  end
  [node[component][:exported_confs]].flatten.compact.each do |export|
    link "#{node[:flume][:conf_dir]}/#{File.basename(export)}" do
      to  export
    end
  end
end

template File.join(node[:flume][:conf_dir], "flume-site.xml") do
  source        "flume-site.xml.erb"
  owner         "root"
  group         "flume"
  mode          "0644"
  variables({
      :flume              => node[:flume],
      :masters            => flume_masters.join(","),
      :plugin_classes     => flume_plugin_classes,
      :classpath          => flume_classpath,
      :master_id          => flume_master_id,
      :external_zookeeper => flume_external_zookeeper,
      :zookeepers         => flume_zookeeper_list,
      :aws_access_key     => node[:aws][:aws_access_key],
      :aws_secret_key     => node[:aws][:aws_secret_access_key],
    })
end

template File.join(node[:flume][:home_dir], "bin/flume-env.sh") do
  source        "flume-env.sh.erb"
  owner         "root"
  mode          "0744"
  variables({
      :flume              => node[:flume],
      :classpath          => flume_classpath,
      :java_opts          => flume_java_opts,
      :rubylib            => node[:flume][:rubylib],
    })
end

%w[commons-codec-1.4.jar commons-httpclient-3.0.1.jar jets3t-0.6.1.jar].each do |file|
  cookbook_file "/usr/lib/flume/lib/#{file}" do
    owner "root"
    mode "644"
  end
end

template node[:flume][:ics_extensions_pom] do
  source 'ics_extensions.pom.xml.erb'
  owner  'root'
  mode   '0644'
  variables({
              :lib_dir                => node[:flume][:lib_dir],
              :ics_extensions_version => node[:flume][:ics_extensions_version]
            })
end
