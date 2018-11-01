all: test pex

cache:
	# vytvorime pycache
	python main.py >/dev/null || true

pex: cache
	pex . pystache typing -e vindaloo.vindaloo:run -o latest/vindaloo.pex --python-shebang='/usr/bin/env python3' --disable-cache

test:
	py.test tests

coverage:
	py.test --cov=vindaloo --cov-report html tests

clean:
	sudo find . -name '__pycache__' -exec rm -rf {} +;
	sudo find . -name '*.pyc' -exec rm -rf {} +;

install-dev:
	pip install pex pystache typing

test-all: clean 3.7-alpine 3.6-alpine 3.5-alpine

%-alpine:
	docker run --rm -v $(PWD):/x python:$@ sh -c "pip install pytest pystache typing; cd /x; pytest tests"

pex-in-docker:
	docker run --rm -v $(PWD):/x python:3.5-alpine sh -c "apk add --no-cache make && cd /x && make install-dev pex"

.PHONY: all cache pex test coverage clean test-all
