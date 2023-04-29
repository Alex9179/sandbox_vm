Vagrant.configure("2") do |config|

# set up of the machine itself	
config.vm.box = "generic/ubuntu2204"

# Box setup
  config.vm.provider "virtualbox" do |vb|
    vb.memory = 8000
    vb.cpus = 2
    vb.customize ["modifyvm", :id, "--cableconnected1", "on"]
    vb.customize ["modifyvm", :id, "--uart1", "0x3F8", "4"]
    vb.customize ["modifyvm", :id, "--uartmode1", "file", File::NULL]
    vb.customize ["modifyvm", :id, "--audio", "none"]
    vb.customize ["modifyvm", :id, "--usb", "off"]
    vb.customize ["modifyvm", :id, "--uart1", "off"]
    vb.customize ["modifyvm", :id, "--uart2", "off"]
    vb.customize ["modifyvm", :id, "--uart3", "off"]
    vb.customize ["modifyvm", :id, "--uart4", "off"]
  end

# back end code - comment out before we install it
config.vm.synced_folder "C:/Users/alexr/Sandbox/sandbox_be", "/var/www/html"

  # network stuff
  config.vm.network "forwarded_port", guest: 3306, host: 3306, host_ip: "127.0.0.1"
  config.vm.network "forwarded_port", guest: 5900, host: 5900, host_ip: "127.0.0.1"
  config.vm.network "forwarded_port", guest: 5432, host: 5432, host_ip: "127.0.0.1"
  config.vm.network "forwarded_port", guest: 80, host: 80, host_ip: "127.0.0.1"
  config.vm.network "forwarded_port", guest: 5432, host: 5432, host_ip: "127.0.0.1"

# install script
config.vm.provision "shell", path: "provision.sh"

end