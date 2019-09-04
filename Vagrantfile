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
  #config.disksize.size = params["disksize_size"]

  config.vm.define "box" do |box|
    box.vm.box = params["vm_box"]
    box.vm.box_check_update = false
    box.vm.network "forwarded_port", guest: 8080, host: 8080
    box.vm.synced_folder "projects", "/projects", create: true
    box.vm.provider "virtualbox" do |vb|
      vb.gui = false
      vb.customize ["modifyvm", :id, "--memory", params["vm_memory"]]
      disk_file = File.realpath( "." ).to_s + "/disk.vdi"
      if ARGV[0] == "up" && ! File.exist?(disk_file)
        vb.customize ['createhd',
          '--filename', disk_file, 
          '--format', 'VDI', 
          '--size', 5000 * 1024 # 5 GB
        ]
        vb.customize ['storagectl', :id,
          '--name', 'SATA Controller', 
          '--add', 'sata', 
          '--controller', 'IntelAhci'
        ]
        vb.customize ['storageattach', :id,
          '--storagectl', 'SATA Controller',
          '--port', 1,
          '--boxice', 0,
          '--type', 'hdd',
          '--medium', disk_file
        ]
      end    
    end
    provision_args = []
    provision_args.push('--use-local-mirror') if params["provision_use_local_mirror"]
    #box.vm.provision "shell", path: params["vm_provision"], args: provision_args, privileged: false
    box.vm.provision "shell", path: "provision/create-disk"
  end
end
