PYTHON = python

.PHONY: test-local
test-local:
	export LINTIAN_ROOT=../../ && \
	$(PYTHON) ./run-tests --verbose

.PHONY: test-installed
test-installed:
	$(PYTHON) ./run-tests --verbose

# vim: syntax=make ts=4 sw=4 noet
