.PHONY: all
all: test

.PHONY: test
test: test-base test-desktop test-server

.PHONY: test-base
test-base: test-debian-base test-arch-base

.PHONY: test-desktop
test-desktop: test-debian-desktop test-arch-desktop

.PHONY: test-server
test-server: test-debian-server

.PHONY: clean
clean: clean-debian clean-arch

.PHONY: test-%-base
test-%-base:
	@echo Testing %.sh...
	@sh test/integration_test.sh % --net-if 'eth*'

.PHONY: test-%-desktop
test-%-desktop:
	@echo Testing %.sh for development desktop setup...
	@sh test/integration_test.sh % --net-if 'eth*' --develop --dot-ssh '/vagrant/test/dot.ssh' --git-user-name foobar --git-user-email foobar@test.example --desktop

.PHONY: test-%-server
test-%-server:
	@echo Testing %.sh for server setup...
	@sh test/integration_test.sh % --net-if 'eth*' --server

.PHONY: clean-debin
clean-debian:
	@vagrant destroy -f debian

.PHONY: clean-arch
clean-arch:
	@vagrant destroy -f arch

.PHONY: test-debian-scripts-%
test-debian-scripts-%: scripts/%.sh
	@echo Testing $< for debian...
	@sh test/unit_test.sh debian $<

.PHONY: test-arch-scripts-%
test-arch-scripts-%: scripts/%.sh
	@echo Testing $< for Arch Linux...
	@sh test/unit_test.sh arch $<
