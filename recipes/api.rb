include_recipe "git"
include_recipe "nginx"
include_recipe "runit"
include_recipe "zeromq"

username     = "citrus-api"
home_dir     = "/var/lib/#{username}"
ruby_version = "2.0.0-p353"

package "sqlite3"
package "sqlite3-dev" do
  package_name value_for_platform(
      %w(centos redhat suse fedora) => {"default" => "sqlite-devel"},
      "default" => "libsqlite3-dev"
  )
end

mongrel_source = ::File.join(Chef::Config[:file_cache_path], "mongrel2-1.8.1.tar.gz")

remote_file mongrel_source do
  source "https://github.com/zedshaw/mongrel2/archive/v1.8.1.tar.gz"
  mode   "0644"
  action :create_if_missing
end

execute "install mongrel2" do
  cwd Chef::Config[:file_cache_path]
  command <<-EOS
    tar zxvf mongrel2-1.8.1.tar.gz
    cd mongrel2-1.8.1
    make all
    make install
  EOS
  not_if { ::File.exist?("/usr/local/bin/mongrel2") }
end

user username do
  home home_dir
  supports :manage_home => true
  action :create
end

ruby "#{ruby_version}-#{username}" do
  version ruby_version
  home home_dir
  owner username
end

hostsfile_entry "127.0.0.1" do
  hostname "api.citrus.arkency"
  action :append
end

deploy_revision home_dir do
  repository "https://github.com/pawelpacana/citrus-web"
  user  username
  group username

  # such hack to clear rails influence on this resource
  symlink_before_migrate.clear
  symlinks.clear

  migrate true
  migration_command "true"
  before_migrate do
    bash "install bundler" do
      code <<-EOS
      export PATH=#{::File.join(home_dir, ruby_version, 'bin')}:$PATH
      gem install bundler
      EOS
      user  username
      group username
    end

    bash "install bundler dependencies" do
      code <<-EOS
      export PATH=#{::File.join(home_dir, ruby_version, 'bin')}:$PATH
      bundle install --path #{::File.join(home_dir, 'shared', 'bundle')}
      EOS
      cwd   release_path
      user  username
      group username
    end
  end

  action :deploy

  notifies :restart, "runit_service[citrus-web]"
  notifies :restart, "runit_service[citrus-mongrel]"
end

runit_service "citrus-web" do
  log false
  options :user => username,
          :home => home_dir,
          :ruby_path => ::File.join(home_dir, ruby_version, 'bin')
end

runit_service "citrus-mongrel" do
  log false
  options :user => username,
          :home => home_dir
end


