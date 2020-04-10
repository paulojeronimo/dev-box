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
  vm = params["vm"]
  config.disksize.size = vm["disk_size"]
  config.vm.define "box" do |box|
    box.vm.box = vm["box"]
    box.vm.box_version = vm["box_version"]
    box.vm.box_check_update = false
    if vm.has_key?('forwarded_ports')
      vm["forwarded_ports"].each do |port|
        box.vm.network "forwarded_port", guest: port["guest"], host: port["host"]
      end
    end
    box.vm.provider "virtualbox" do |vb|
      vb.gui = vm["gui"]
      vb.name = vm["name"]
      vb.memory = vm["memory"]
      vb.cpus = vm["cpus"]
    end
    if vm.has_key?('provision')
      vm["provision"][:path] = "provision/install"
    else
      vm.store("provision", { :path => "provision/install" })
    end
    provision_args = []
    if vm["provision"].has_key?('args')
      vm["provision"]["args"].each do |arg|
        provision_args.push(arg)
      end
    end
    box.vm.provision "shell", path: vm["provision"][:path], args: provision_args, privileged: false
  end
end
