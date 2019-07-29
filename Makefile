PKGNAME		= bisk
PKGDESC		= Backup all data block devices

BINDIR  	= $(DESTDIR)/usr/bin

install:
	mkdir -p $(BINDIR)
	chmod 755 $(PKGNAME)
	cp $(PKGNAME) $(BINDIR)/$(PKGNAME)

uninstall:
	$(RM) $(BINDIR)/$(PKGNAME)

.PHONY: install uninstall
