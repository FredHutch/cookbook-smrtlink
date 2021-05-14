#
# Cookbook:: smrtlink
# Recipe:: default
#
# Copyright:: 2021, The Authors, All Rights Reserved.

user 'smrtlink user' do
  username node['smrtlink']['user']['username']
  home node['smrtlink']['user']['home']
  only_if { node['smrtlink']['user']['manage_user'] == true }
end

if node['smrtlink']['local_dirs']
  node['smrtlink']['local_dirs'].each do |source, target|
    directory target['target'] do
      owner node['smrtlink']['user']['username']
      mode '0755'
      recursive true
    end
    link source do
      to target['target']
      only_if { target['link'] == true }
    end
  end
end

bash 'daemon-reload' do
  code '/bin/systemctl daemon-reload'
  action :nothing
  only_if { node['smrtlink']['service']['reload'] == true }
end

systemd_unit 'smrtlink.service' do
  content(
    Unit: {
      Description: 'PacBio SMRTLink Server',
      After: 'multi-user.target',
    },
    Service: {
      User: node['smrtlink']['user']['username'],
      Type: 'oneshot',
      LimitNOFILE: '10240',
      RemainAfterExit: 'true',
      EnvironmentFile: '-/etc/default/smrtlink',
      ExecStart: "#{node['smrtlink']['paths']['SMRT_ROOT']}/admin/bin/services-start",
      ExecStop: "#{node['smrtlink']['paths']['SMRT_ROOT']}/admin/bin/services-stop",
    },
    Install: {
      WantedBy: 'multi-user.target',
    }
  )
  action [:create]
  verify false
  notifies :run, 'bash[daemon-reload]', :delayed
end
