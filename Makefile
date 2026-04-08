.PHONY: all
all: test

.PHONY: check
check: check-github-actions

.PHONY: test
test: test-arch test-debian

.PHONY: test-arch
test-arch:
	@make test-base TARGET=arch
	@make test-desktop TARGET=arch
	@make test-server TARGET=arch

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
	@sh test/integration_test.sh $(TARGET) --net-if 'eth*' --develop --dot-ssh '/mnt/setup/test/dot.ssh' --git-user-name foobar --git-user-email foobar@test.example --desktop

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
	@rm -f img.qcow2 seed.img user-data

.PHONY: check-github-actions
check-github-actions:
	zizmor -p .github

.PHONY: pin
pin: pin-github-actions

.PHONY: pin-github-actions
pin-github-actions:
	pinact run
