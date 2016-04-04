name             'cog_clamav'
maintainer       'Cash on Go Ltd'
maintainer_email 'lauri.jesmin@cashongo.co.uk'
license          'All rights reserved'
description      'Installs/Configures cog_clamav'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.2.2'

depends 'cron',         '~> 1.6.0'
depends 'yum-epel',     '~> 0.6.0'
