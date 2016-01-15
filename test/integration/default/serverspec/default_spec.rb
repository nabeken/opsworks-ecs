require 'spec_helper'

describe docker_image('amazon/amazon-ecs-agent:latest') do
  it { should exist }
end

describe docker_container('ecs-agent') do
  it { should be_running }

  %w{
    /data:/var/lib/ecs/data
    /log:/var/log/ecs
    /sys/fs/cgroup:/sys/fs/cgroup
    /var/run/docker.sock:/var/run/docker.sock
    /var/lib/docker/execdriver/native:/var/run/docker/execdriver/native
  }.each do |v|
    volumes = v.split(':')
    it { should have_volume(*volumes) }
  end

  %w{
    ECS_CLUSTER=opsworks-ecs
    ECS_LOGFILE=/log/ecs-agent.log
    ECS_LOGLEVEL=info
    ECS_DATADIR=/data
  }.each do |env|
    its(['Config.Env']) { should include env }
  end
end

describe port(51678) do
  it { should be_listening }
end

describe file('/var/log/ecs') do
    it { should be_directory }
    it { should be_mode 700 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
end

describe file('/var/lib/ecs') do
    it { should be_directory }
    it { should be_mode 700 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
end

describe file('/var/lib/ecs/data') do
    it { should be_directory }
    it { should be_mode 700 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
end
