# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  params = if File.exists?("config.yaml") then YAML::load_file("config.yaml") else YAML::load_file("config-default.yaml") end

  required_plugins = %w( vagrant-vbguest vagrant-disksize )
  _retry = false
  required_plugins.each do |plugin|
    unless Vagrant.has_plugin? plugin
      system "vagrant plugin install #{plugin}"
        _retry=true
    end
  end

  if (_retry)
    exec "vagrant " + ARGV.join(' ')
  end

  config.vbguest.auto_update = params["vbguest_auto_update"]
  config.disksize.size = params["disksize_size"]

  config.vm.box = params["vm_box"]
  config.vm.box_check_update = false
  config.vm.network "forwarded_port", guest: 8080, host: 8080
  config.vm.synced_folder "projects", "/projects", create: true
  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.customize ["modifyvm", :id, "--memory", params["vm_memory"]]
  end
  provision_args = []
  provision_args.push('--use-local-mirror') if params["provision_use_local_mirror"]
  config.vm.provision "shell", path: params["vm_provision"], args: provision_args, privileged: false
end
