# Package information

pkgid = agda-web-uri

# Include the Agda makefile

export agdamakefileuri ?= https://github.com/agda/agda-makefile/raw/v0.0.2/Makefile
export agdamakefile ?= $(CURDIR)/build/share/make/agda-makefile
export CURL ?= curl

$(agdamakefile):
	$(CURL) --create-dir -o $@ $(agdamakefileuri)

include $(agdamakefile)

# Targets

.PHONY: install-agda install-html install-doc install clean veryclean

install-agda: $(agdadir)/Web/URI/Everything.agdai

install-html: $(htmldir)/Web/URI/Everything.html

install-bin: install-cabal-network $(bindir)/Web/URI/Examples/HelloWorld

install-doc:
	$(INSTALL) -D README $(docdir)
	$(INSTALL) -D LICENSE $(docdir)

install: install-agda install-html install-bin install-doc

clean:

veryclean:
	rm -rf $(builddir)
