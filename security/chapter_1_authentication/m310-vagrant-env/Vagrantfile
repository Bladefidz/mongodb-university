if Vagrant::VERSION < "2.0.0"
  $stderr.puts "Must redirect to new repository for old Vagrant versions"
  Vagrant::DEFAULT_SERVER_URL.replace('https://vagrantcloud.com')
end

Vagrant.configure("2") do |config|
  config.vm.define :database do |database|
    database.vm.box = "ubuntu/trusty64"
    database.vm.network :private_network, ip: "192.168.31.100"
    database.vm.hostname = "database.m310.mongodb.university"
    database.vm.provision :shell, path: "provision-database", args: ENV['ARGS']
    database.vm.synced_folder "shared/", "/home/vagrant/shared", create: true

    database.vm.provider "virtualbox" do |vb|
      vb.customize ["modifyvm", :id, "--cpus", "1", "--memory", 1024]
    end
  end

  config.vm.define :infrastructure do |infrastructure|
    infrastructure.vm.box = "centos/7"
    infrastructure.vm.network :private_network, ip: "192.168.31.200"
    infrastructure.vm.hostname = "infrastructure.m310.mongodb.university"
    infrastructure.vm.provision :shell, path: "provision-infrastructure", args: ENV['ARGS']
    infrastructure.vm.synced_folder "shared/", "/home/vagrant/shared", create: true

    infrastructure.vm.provider "virtualbox" do |v|
      v.customize ["modifyvm", :id, "--cpus", "1"]
    end
  end
end
