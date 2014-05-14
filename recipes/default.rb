user 'deploy' do
  action :create
  system true
  shell '/bin/false'
end

directory '/opt/deploy' do
  owner 'deploy'
  group 'deploy'
  mode '0755'
  action :create
end

directory '/opt/deploy/sample-app' do
  owner 'deploy'
  group 'deploy'
  mode '0755'
  action :create
end

git '/opt/deploy/sample-app' do
  repository 'https://github.com/patarleth/sample-express-app.git'
  revision 'master'
  action :sync
end

execute 'npm_install' do
  command 'npm install'
  cwd '/opt/deploy/sample-app'
end

bash 'pown' do
  code <<-EOH
chown -R deploy:deploy /opt/deploy
  EOH
end

template "sample-app.upstart.conf" do
  path "/etc/init/sample-app.conf"
  source "sample-app.upstart.conf.erb"
  owner "root"
  group "root"
  mode "0644"
end

service "sample-app" do
  provider Chef::Provider::Service::Upstart
  supports :restart => true, :start => true, :stop => true
  action [:enable, :start]
end


