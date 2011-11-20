prefix = ${shell arc --show-prefix}

bindir   = $(DESTDIR)/$(prefix)/bin
libdir   = $(DESTDIR)/$(prefix)/lib/arc/site
sharedir = $(DESTDIR)/$(prefix)/share/arc

all:

install:
	mkdir -p $(bindir)
	cp ./bin/eponad $(bindir)/eponad
	mkdir -p $(libdir)
	cp ./lib/epona.arc $(libdir)/epona.arc
	cp -r ./lib/epona $(libdir)/

uninstall:
	rm -rf $(bindir)/eponad
	rm -rf $(libdir)/epona.arc
	rm -rf $(libdir)/epona
