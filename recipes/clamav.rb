#
# Cookbook Name:: cog_clamav
# Recipe:: clamav
#
# Copyright (C) 2014 Cash on Go Ltd.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "cron::default"

case node['platform_family'] when 'rhel'
  include_recipe 'yum-epel'
end

package node['cog_clamav']['freshclam_package'] do
  notifies :run,'execute[freshclam]',:delayed
end

package node['cog_clamav']['clamav_package']

cookbook_file node['cog_clamav']['freshclam_config'] do
  action   :create
  source   'freshclam.conf'
  owner    'root'
  group    'root'
  mode     '0644'
  cookbook 'cog_clamav'
end

if  node['platform_family'] == 'rhel' && node['platform']!='amazon' then
  cookbook_file '/etc/sysconfig/freshclam' do
    action   :create
    source   'freshclam'
    cookbook 'cog_clamav'
    owner    'root'
    group    'root'
    mode     '0644'
  end
end

execute 'freshclam' do
  action :nothing
  command '/usr/bin/freshclam'
end

noscan = ""

if node['cog_clamav']['clamav_noscan_for_all'].length > 0 && node['cog_clamav']['clamav_noscan_for_all'].kind_of?(Array)
  noscan = " --exclude="+node['cog_clamav']['clamav_noscan_for_all'].join(' --exclude=')
end

if node['cog_clamav']['clamav_noscan'].length > 0 && node['cog_clamav']['clamav_noscan'].kind_of?(Array)
  noscan = noscan+" --exclude="+node['cog_clamav']['clamav_noscan'].join(' --exclude=')
end

if node['cog_clamav']['clamav_disabled_puas'].length > 0 && node['cog_clamav']['clamav_disabled_puas'].kind_of?(Array)
  noscan = noscan+" --exclude-pua="+node['cog_clamav']['clamav_disabled_puas'].join(' --exclude-pua=')
end

cron_d 'cog_clamscan' do
  minute   node['cog_clamav']['scan_minute']
  hour     node['cog_clamav']['scan_hour']
  command  '/usr/bin/chrt -i 0 /usr/bin/clamscan -ri --no-summary --detect-pua=yes '+noscan+' / | /usr/bin/logger -t clamscan -p local0.notice 2>&1'
  user     'root'
  mailto    node['cog_clamav']['clamav_reports']
end
