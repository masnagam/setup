# Took from https://gist.github.com/ilyar/d2ed54b671c997b86cab9d1fe2d021ab
module OS
  def OS.windows?
    (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
  end

  def OS.mac?
    (/darwin/ =~ RUBY_PLATFORM) != nil
  end

  def OS.unix?
    !OS.windows?
  end

  def OS.linux?
    OS.unix? and not OS.mac?
  end
end

Vagrant.configure("2") do |config|
  config.vm.provider "virtualbox" do |vbox|
    if OS.mac?
      cpus = `sysctl -n hw.logicalcpu`.to_i
    else
      cpus = `nproc`.to_i
    end
    vbox.cpus = [(cpus / 2).clamp(1..), 4].min()
    vbox.memory = 4096
  end

  # Workaround for the timeout issue while waiting for the VM to boot.
  config.vm.boot_timeout = 600  # 10m

  config.vm.define "debian" do |debian|
    debian.vm.box = "debian/bookworm64"
    debian.vm.provision "shell", path: "test/debian.provision.sh"
  end

  config.vm.define "arch" do |arch|
    arch.vm.box = "archlinux/archlinux"
    arch.vm.provision "shell", path: "test/arch.provision.sh"
    arch.vm.synced_folder ".", "/vagrant"
  end
end
