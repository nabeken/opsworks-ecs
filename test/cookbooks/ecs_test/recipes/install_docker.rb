#
# Cookbook Name:: docker_deploy_test
# Recipe:: install_docker
#
# Copyright 2015 TANABE Ken-ichi
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

execute 'install-docker' do
  command '/tmp/install_docker.sh'
  action :nothing
end

execute 'enable-device-mapper' do
  command %Q[sed -e 's|^#DOCKER_OPTS=.*|DOCKER_OPTS="-s devicemapper"|' -i /etc/default/docker]
  action :nothing
end

remote_file '/tmp/install_docker.sh' do
  owner 'root'
  group 'root'
  mode '0744'
  source 'https://get.docker.com'
  notifies :run, 'execute[install-docker]', :immediately
  notifies :run, 'execute[enable-device-mapper]', :immediately
end
