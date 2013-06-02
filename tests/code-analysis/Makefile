PYTHON2S = $(shell pyversions -i)
PYTHON3S = $(shell py3versions -i)
PYTHONS = $(PYTHON2S) $(PYTHON3S)

for_all_pythons = echo $(PYTHONS) | xargs -n1 | xargs -t -I {} env {}

.PHONY: test-local
test-local:
	export LINTIAN_ROOT=../../ && \
	$(for_all_pythons) ./run-tests --verbose

.PHONY: test-installed
test-installed:
	$(for_all_pythons) ./run-tests --verbose

# vim: syntax=make ts=4 sw=4 noet
