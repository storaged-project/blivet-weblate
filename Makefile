#
# Makefile for the PO files (translation) catalog
#
# $Id$

TOP	 = ..

# What is this package?
NLSPACKAGE	= blivet
POTFILE		= $(NLSPACKAGE).pot
INSTALL		= /usr/bin/install -c
INSTALL_DATA	= $(INSTALL) -m 644
INSTALL_DIR	= /usr/bin/install -d

# destination directory
INSTALL_NLS_DIR = $(RPM_BUILD_ROOT)/usr/share/locale

# PO catalog handling
MSGMERGE	= msgmerge -v
XGETTEXT	= $(TOP)/translation-canary/xgettext_werror.sh --default-domain=$(NLSPACKAGE) \
		  --add-comments
MSGFMT		= msgfmt --statistics --verbose

# What do we need to do
POFILES		= $(wildcard *.po)
MOFILES		= $(patsubst %.po,%.mo,$(POFILES))
PYSRC		= $(wildcard ../blivet/*.py ../blivet/*/*.py)
SRCFILES 	= $(PYSRC)

all: $(MOFILES)

$(POTFILE): $(SRCFILES)
	$(XGETTEXT) -L Python --keyword=_ --keyword=N_ --keyword=P_:1,2 $(SRCFILES)
	@if cmp -s $(NLSPACKAGE).po $(POTFILE); then \
	    rm -f $(NLSPACKAGE).po; \
	else \
	    mv -f $(NLSPACKAGE).po $(POTFILE); \
	fi; \

clean:
	@rm -fv *mo *~ .depend

install: $(MOFILES)
	@for n in $(MOFILES); do \
	    l=`basename $$n .mo`; \
	    $(INSTALL_DIR) $(INSTALL_NLS_DIR)/$$l/LC_MESSAGES; \
	    $(INSTALL_DATA) --verbose $$n $(INSTALL_NLS_DIR)/$$l/LC_MESSAGES/$(NLSPACKAGE).mo; \
	done

%.mo: %.po
	$(MSGFMT) -o $@ $<

.PHONY: missing depend
