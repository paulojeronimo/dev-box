# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  params = YAML::load_file(if File.exists?("config.yaml") then "config.yaml" else "config-default.yaml" end)

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

  config.vm.define "box" do |box|
    box.vm.box = params["vm_box"]
    box.vm.box_version = params["vm_box_version"]
    box.vm.box_check_update = false
    params["ports"].each do |port|
      box.vm.network "forwarded_port", guest: port["guest"], host: port["host"]
    end
    box.vm.synced_folder "projects", "/projects", create: true
    box.vm.provider "virtualbox" do |vb|
      vb.gui = false
      vb.name = params["vm_name"]
      vb.memory = params["vm_memory"]
      vb.cpus = params["vm_cpus"]
    end
    provision_args = []
    provision_args.push('--use-local-mirror') if params["provision_use_local_mirror"]
    box.vm.provision "shell", path: params["vm_provision"], args: provision_args, privileged: false
    #box.vm.provision "shell", path: "provision/resize-disk", privileged: false
  end
end
