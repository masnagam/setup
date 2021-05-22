.PHONY: all
all: test

.PHONY: test
test: test-debian

.PHONY: test-debian
test-debian: test-debian-base test-debian-desktop

.PHONY: test-debian-base
test-debian-base:
	@echo Testing debian.sh...
	@sh test/integration_test.sh debian --net-if 'eth*'

.PHONY: test-debian-desktop
test-debian-desktop:
	@echo Testing debian.sh...
	@sh test/integration_test.sh debian --net-if 'eth*' --develop --dot-ssh '/vagrant/test/dot.ssh' --git-user-name vagrant --git-user-email vagrant@test.example --desktop

.PHONE: test-debian-scripts-%
test-debian-scripts-%: scripts/%.sh
	@echo Testing $<... on Debian
	@sh test/unit_test.sh debian $<
