# encoding: utf-8

name             'citrus'
maintainer       'Paweł Pacana'
maintainer_email 'pawel.pacana@syswise.eu'
license          'All rights reserved'
description      'Installs/Configures citrus'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends          'ruby-build'
depends          'git'
depends          'nginx'
depends          'runit'
depends          'readline'
depends          'build-essential'
depends          'zlib'
depends          'hostsfile'
depends          'zeromq'
