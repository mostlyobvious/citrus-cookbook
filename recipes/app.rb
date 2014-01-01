include_recipe "nginx"

username = "citrus-app"
home_dir = "/var/lib/#{username}"

user username do
  home home_dir
  supports :manage_home => true
  action :create
end

hostsfile_entry "127.0.0.1" do
  hostname "app.citrus.arkency"
  action :append
end

deploy_revision home_dir do
  repository "https://github.com/pawelpacana/citrus-spa"
  user username

  # such hack to clear rails influence on this resource
  symlink_before_migrate.clear
  symlinks.clear
end


