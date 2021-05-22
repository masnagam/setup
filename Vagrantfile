Vagrant.configure("2") do |config|
  config.vm.provider "virtualbox" do |vbox|
    vbox.cpus = `sysctl -n hw.logicalcpu`.to_i / 2
    vbox.memory = 2048
  end

  config.vm.define "debian" do |debian|
    debian.vm.box = "debian/buster64"
    debian.vm.provision "shell", path: "test/debian.provision.sh"
  end
end
