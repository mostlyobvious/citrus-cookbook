# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.hostname = "citrus-berkshelf"
  config.vm.box      = "ubuntu"
  config.vm.box_url  = "http://cloud-images.ubuntu.com/vagrant/precise/current/precise-server-cloudimg-amd64-vagrant-disk1.box"

  # Assign this VM to a host-only network IP, allowing you to access it
  # via the IP. Host-only networks can talk to the host machine as well as
  # any other machines on the same network, but cannot be accessed (through this
  # network interface) by any external networks.
  config.vm.network :private_network, ip: "33.33.33.10"

  # https://github.com/berkshelf/vagrant-berkshelf
  config.berkshelf.enabled = true

  # https://github.com/schisamo/vagrant-omnibus
  config.omnibus.chef_version = :latest

  # https://github.com/dotless-de/vagrant-vbguest
  config.vbguest.auto_update = true

  # An array of symbols representing groups of cookbook described in the Vagrantfile
  # to exclusively install and copy to Vagrant's shelf.
  # config.berkshelf.only = []

  # An array of symbols representing groups of cookbook described in the Vagrantfile
  # to skip installing and copying to Vagrant's shelf.
  # config.berkshelf.except = []

  config.vm.provision :chef_solo do |chef|
    chef.json = {
      :mysql => {
        :server_root_password   => 'rootpass',
        :server_debian_password => 'debpass',
        :server_repl_password   => 'replpass'
      }
    }

    chef.arguments = "-l debug"
    chef.run_list  = [
        #"recipe[minitest-handler::default]",
        "recipe[citrus::default]"
    ]
  end
end
