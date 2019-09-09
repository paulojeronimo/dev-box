#!/usr/bin/env ruby
# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'yaml'

config_dir = File.expand_path(File.dirname(__FILE__) + "/..")
Dir.chdir config_dir do
  params = YAML.load_file(if File.exists?("config.yaml") then "config.yaml" else "config-default.yaml" end)
  vm = params["vm"]
  if vm.has_key?('forwarded_ports')
    puts "forwarded_ports:"
    vm["forwarded_ports"].each do |port|
      puts "\tguest: #{port["guest"]}, host: #{port["host"]}"
    end
  end
end
