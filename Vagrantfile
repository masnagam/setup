Vagrant.configure("2") do |config|
  config.vm.boot_timeout = 60

  config.vm.provider "virtualbox" do |vbox|
    vbox.cpus = (`sysctl -n hw.logicalcpu`.to_i / 2).clamp(1..4)
    vbox.memory = 2048
  end

  config.vm.define "debian" do |debian|
    debian.vm.box = "debian/bullseye64"
    debian.vm.provision "shell", path: "test/debian.provision.sh"
  end

  config.vm.define "arch" do |arch|
    # Use the generic/arch box instead of the archlinux/archlinux box.
    #
    # The archlinux/archlinux box is released officially from Arch Linux project.  However,
    # this box takes more than 1 minute to start sshd unfortunately.  Because it invokes
    # the reflector-init.service for updating /etc/pacman.d/mirrorlist.
    # https://gitlab.archlinux.org/archlinux/arch-boxes/-/blob/v20210619.26314/images/base.sh#L52
    #arch.vm.box = "archlinux/archlinux"
    arch.vm.box = "generic/arch"
    arch.vm.provision "shell", path: "test/arch.provision.sh"
    arch.vm.synced_folder ".", "/vagrant"
  end
end
