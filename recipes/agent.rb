#
# Cookbook Name:: opsworks-ecs
# Recipe:: agent
#
# Copyright 2016 TANABE Ken-ichi
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

docker_image 'amazon/amazon-ecs-agent' do
  tag node['opsworks_ecs']['agent']['tag']
  action :pull
  notifies :redeploy, 'docker_container[ecs-agent]'
end

docker_container 'ecs-agent' do
  image 'amazon/amazon-ecs-agent'
  tag node['opsworks_ecs']['agent']['tag']
  action :run_if_missing
  detach true
  port '127.0.0.1:51678:51678'
  restart_policy 'on-failure'
  restart_maximum_retry_count 10
  env lazy {
    ::File.open('/etc/ecs/ecs.config').read.split("\n")
  }
  binds %w{
    /var/run/docker.sock:/var/run/docker.sock
    /var/log/ecs/:/log
    /var/lib/ecs/data:/data
    /sys/fs/cgroup:/sys/fs/cgroup:ro
    /var/run/docker/execdriver/native:/var/lib/docker/execdriver/native:ro
  }
end
