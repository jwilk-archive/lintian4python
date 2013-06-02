.PHONY: test-local
test-local:
	$(MAKE) -C code-analysis/ PYTHON=python test-local
	$(MAKE) -C code-analysis/ PYTHON=python3 test-local
	$(MAKE) -C blackbox/ test-local

.PHONY: test-installed
test-installed:
	$(MAKE) -C code-analysis/ PYTHON=python test-installed
	$(MAKE) -C code-analysis/ PYTHON=python3 test-installed
	$(MAKE) -C blackbox/ test-installed

# vim: syntax=make ts=4 sw=4 noet
