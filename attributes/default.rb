default['cog_clamav']['clamav_reports']         = 'admin@cashongo.co.uk'

default['cog_clamav']['clamav_package']         = 'clamav'

case node['platform_family']
  when 'rhel'
    default['cog_clamav']['freshclam_package']  = 'clamav-update'
    default['cog_clamav']['freshclam_config']   = '/etc/freshclam.conf'
  when 'debian'
    default['cog_clamav']['freshclam_package']  = 'clamav-freshclam'
    default['cog_clamav']['freshclam_config']   = '/etc/clamav/freshclam.conf'
  end

default['cog_clamav']['clamav_noscan_for_all']  = [
  '^/sys',
  '^/dev',
  '^/proc',
  '^/net',
  '^/var/lib/mysql',
  '^/var/lib/mongodb',
  '^/etc/suricata',
  '^/root/suricata'
]

default['cog_clamav']['clamav_noscan']          = [
  '^/usr/share/mime/mime.cache',
  '^/var/log/logstash-forwarder/logstash-forwarder.err'
]

default['cog_clamav']['clamav_disabled_puas']   = [
  'HTML', 'Script', 'Win.Packer','Win.Exploit'
]

default['cog_clamav']['scan_hour']              = 23
default['cog_clamav']['scan_minute']            = 0
