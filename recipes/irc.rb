username     = "citrus-irc"
home_dir     = "/var/lib/#{username}"
ruby_version = "2.0.0-p353"

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

deploy_revision home_dir do
  repository "https://github.com/pawelpacana/citrus-irc"
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

  notifies :restart, "runit_service[citrus-irc]"
end

runit_service "citrus-irc" do
  log false
  options :user => username,
          :home => home_dir,
          :ruby_path => ::File.join(home_dir, ruby_version, "bin"),
          :host => "irc.arkency",
          :channel => "#citrus"
end


