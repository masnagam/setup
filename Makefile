.PHONY: all
all: test

.PHONY: test
test: test-arch test-debian

.PHONY: test-arch
test-arch:
	@make test-base TARGET=arch
	@make test-desktop TARGET=arch

.PHONY: test-debian
test-debian:
	@make test-base TARGET=debian
	@make test-desktop TARGET=debian
	@make test-server TARGET=debian

.PHONY: test-base
test-base:
	@echo "Testing $(TARGET).sh..."
	@sh test/integration_test.sh $(TARGET) --net-if 'eth*'

.PHONY: test-desktop
test-desktop:
	@echo "Testing $(TARGET).sh for development desktop setup..."
	@sh test/integration_test.sh $(TARGET) --net-if 'eth*' --develop --dot-ssh '/vagrant/test/dot.ssh' --git-user-name foobar --git-user-email foobar@test.example --desktop

.PHONY: test-server
test-server:
	@echo "Testing $(TARGET).sh for server setup..."
	@sh test/integration_test.sh $(TARGET) --net-if 'eth*' --server --email foobar@test.example

.PHONY: test-scripts-%
test-scripts-%: scripts/%.sh
	@echo "Testing $< for $(TARGET)..."
	@sh test/unit_test.sh $(TARGET) $<

.PHONY: clean
clean:
	@vagrant destroy -f $(TARGET)
