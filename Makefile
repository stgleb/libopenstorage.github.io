HAS_PROTOC := $(shell command -v protoc 2> /dev/null)
HAS_PROTOGENDOC := $(shell command -v protoc-gen-doc 2> /dev/null)
all: build

images:
	$(MAKE) -C docs/images

build: images docs/reference.md
	gitbook build docs/ w

serve: images docs/reference.md
	gitbook serve docs/ w

api:
ifndef HAS_PROTOC
	$(error "Please install protoc 1.3.3 or later")
endif
ifndef HAS_PROTOGENDOC
	$(error "Please install protoc-gen-doc. See README.md for more information")
endif
	bash getcontent.sh

docs/reference.md: api

# If you have updated any plugins in docs/book.json from https://plugins.gitbook.com/
# you will need to update the modules
update-modules:
	cd docs && rm -rf node_modules && gitbook install


.PHONY: all build serve images api
