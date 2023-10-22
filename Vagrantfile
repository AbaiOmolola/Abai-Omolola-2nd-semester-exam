
Vagrant.configure("2") do |config|
   config.vm.define "slave" do |slave_1|
     slave_1.vm.hostname = "slave"
     slave_1.vm.box = "ubuntu/focal64"
     slave_1.vm.network "private_network", ip: "192.168.60.12"

     slave_1.vm.provision "shell", inline: <<-SHELL
     sudo apt-get update && sudo apt-get upgrade -y
     sudo apt install sshpass -y
     sudo apt-get install -y avahi-daemon libnss-mdnns
     SHELL
    end
    
    config.vm.define "master" do |master_1|
     master_1.vm.hostname = "master"
     master_1.vm.box = "ubuntu/focal64"
     master_1.vm.network "private_network", ip: "192.168.60.11"
     master_1.vm.provision "shell", inline: <<-SHELL
     sudo apt-get update && sudo apt-get upgrade -y
     sudo apt-get install -y avahi-daemon libnss-mdns
     sudo apt install sshpass -y
     SHELL
    end
    config.vm.provider "virtualbox" do |vb|
     vb.memory = "1024"
     vb.cpus = "2"
    end
end
