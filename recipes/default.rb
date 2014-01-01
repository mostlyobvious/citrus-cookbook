#
# Cookbook Name:: citrus
# Recipe:: default
#
# Copyright (C) 2013 Paweł Pacana
#
# All rights reserved - Do Not Redistribute
#

case node.platform
when "debian", "ubuntu"
  package "libssl-dev"
when "redhat", "centos", "fedora"
  package "openssl-devel"
  package "openssl"
end

include_recipe "citrus::api"
include_recipe "citrus::app"
include_recipe "citrus::irc"

# verbose provision in berkshelf/vagrant
# git hostfile_entry resources names maybe

