Vagrant.configure("2") do |config|

# set up of the machine itself	
config.vm.box = "ubuntu/focal64"
config.vm.network "forwarded_port", guest: 80, host: 8080

#networking
config.vm.hostname = 'am.sandbox.com'
config.vm.network "forwarded_port", guest: 3306, host: 3306, host_ip: "127.0.0.1"
config.vm.network "forwarded_port", guest: 5900, host: 5900, host_ip: "127.0.0.1"
config.vm.network "forwarded_port", guest: 5432, host: 5432, host_ip: "127.0.0.1"
config.vm.network "forwarded_port", guest: 5434, host: 5434, host_ip: "127.0.0.1"
config.vm.network "forwarded_port", guest: 2345, host: 2345, host_ip: "127.0.0.1"
config.vm.network "forwarded_port", guest: 80, host: 8080, auto_correct: true

# back end code - comment out before we install it
#config.vm.synced_folder = "C:/Users/alexr/Sandbox/sandbox_be", "var/www/html"

# install script
config.vm.provision "shell", path: "provision.sh"

end