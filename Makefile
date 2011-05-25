# Package information

pkgid = agda-web-uri
dependencies = agda-data-bindings

# Dependency URIs

export agda-data-bindings ?= https://github.com/agda/agda-data-bindings/tarball/v0.0.2

# Include the Agda makefile

export agdamakefileuri ?= https://github.com/agda/agda-makefile/raw/v0.0.6/Makefile
export agdamakefile ?= $(CURDIR)/build/share/make/agda-makefile-0.0.6
export CURL ?= curl

$(agdamakefile):
	$(CURL) --create-dir -o $@ $(agdamakefileuri)

include $(agdamakefile)

# Targets

.PHONY: install-agda install-html install-doc install clean veryclean

install-agda: $(agdadir)/Web/URI/Everything.agdai

install-html: $(htmldir)/Web.URI.Everything.html

install-bin: install-cabal-network $(bindir)/Web/URI/Examples/HelloWorld

install-doc:
	$(INSTALL) -D README $(docdir)
	$(INSTALL) -D LICENSE $(docdir)

install: install-dependencies install-agda install-html install-bin install-doc

clean:

veryclean:
	rm -rf $(builddir)
