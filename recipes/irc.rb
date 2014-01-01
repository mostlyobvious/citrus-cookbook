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


