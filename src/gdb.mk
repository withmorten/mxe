# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := gdb
$(PKG)_WEBSITE  := https://www.gnu.org/software/gdb/
$(PKG)_VERSION  := 8.1
$(PKG)_CHECKSUM := af61a0263858e69c5dce51eab26662ff3d2ad9aa68da9583e8143b5426be4b34
$(PKG)_SUBDIR   := gdb-$($(PKG)_VERSION)
$(PKG)_FILE     := gdb-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://ftp.gnu.org/gnu/$(PKG)/$($(PKG)_FILE)
$(PKG)_URL_2    := https://ftpmirror.gnu.org/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc dlfcn-win32 expat libiconv readline zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://ftp.gnu.org/gnu/gdb/?C=M;O=D' | \
    $(SED) -n 's,.*<a href="gdb-\([0-9][^"]*\)\.tar.*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --with-system-readline \
        --disable-gdbtk \
        --disable-tui \
        host_configargs="LIBS=\"`$(TARGET)-pkg-config --libs dlfcn`\"" \
        CONFIG_SHELL=$(SHELL)
    $(MAKE) -C '$(1)' -j '$(JOBS)'

    # executables are always static and we don't the rest
     $(INSTALL) -m755 '$(1)/gdb/gdb.exe'                 '$(PREFIX)/$(TARGET)/bin/'
     $(INSTALL) -m755 '$(1)/gdb/gdbserver/gdbserver.exe' '$(PREFIX)/$(TARGET)/bin/'
endef
