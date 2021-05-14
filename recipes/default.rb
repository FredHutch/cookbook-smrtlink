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
    end
    link source do
      to target['target']
      only_if { target['link'] == true }
    end
  end
end
