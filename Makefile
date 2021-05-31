.PHONY: all
all: test

.PHONY: test
test: test-debian

.PHONY: test-debian
test-debian: test-debian-base test-debian-desktop test-debian-server

.PHONY: test-debian-base
test-debian-base:
	@echo Testing debian.sh...
	@sh test/integration_test.sh debian --net-if 'eth*'

.PHONY: test-debian-desktop
test-debian-desktop:
	@echo Testing debian.sh for development desktop setup...
	@sh test/integration_test.sh debian --net-if 'eth*' --develop --dot-ssh '/vagrant/test/dot.ssh' --git-user-name foobar --git-user-email foobar@test.example --desktop

.PHONY: test-debian-server
test-debian-server:
	@echo Testing debian.sh for server setup...
	@sh test/integration_test.sh debian --net-if 'eth*' --server

.PHONY: test-debian-scripts-%
test-debian-scripts-%: scripts/%.sh
	@echo Testing $<... on Debian
	@sh test/unit_test.sh debian $<

.PHONY: clean
clean:
	@vagrant destroy -f debian
