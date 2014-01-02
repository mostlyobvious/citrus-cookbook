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
  user  username
  group username

  # such hack to clear rails influence on this resource
  symlink_before_migrate.clear
  symlinks.clear
end

template "/etc/nginx/sites-available/citrus-app" do
  source "nginx-frontend.erb"
  variables :server_name => "app.citrus.arkency",
            :root => ::File.join(home_dir, "current", "public")
  notifies :reload, "service[nginx]"
end

nginx_site "citrus-app"


