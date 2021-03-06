# Copyright (C) 2015  Sunny <ratsunny@gmail.com>
#
# This file is part of Shadowsocks-NaCl.
#
# Shadowsocks-NaCl is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Shadowsocks-NaCl is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.


VALID_TOOLCHAINS := pnacl


NACL_SDK_ROOT ?= $(HOME)/nacl_sdk/pepper_41
include $(NACL_SDK_ROOT)/tools/common.mk


TARGET = shadowsocks
LIBS = ppapi_cpp ppapi crypto sodium
CFLAGS = -std=gnu++11 -Wall
SOURCES = src/module.cc \
          src/shadowsocks.cc \
          src/encrypt.cc \
          src/crypto/crypto.cc \
          src/crypto/openssl.cc \
          src/socks5.cc \
          src/tcp_relay.cc \
          src/tcp_relay_handler.cc


# Build rules generated by macros from common.mk:
$(foreach dep,$(DEPS),$(eval $(call DEPEND_RULE,$(dep))))
$(foreach src,$(SOURCES),$(eval $(call COMPILE_RULE,$(src),$(CFLAGS))))


# The PNaCl workflow uses both an unstripped and finalized/stripped binary.
# On NaCl, only produce a stripped binary for Release configs (not Debug).
ifneq (,$(or $(findstring pnacl,$(TOOLCHAIN)),$(findstring Release,$(CONFIG))))
$(eval $(call LINK_RULE,$(TARGET)_unstripped,$(SOURCES),$(LIBS),$(DEPS)))
$(eval $(call STRIP_RULE,$(TARGET),$(TARGET)_unstripped))
else
$(eval $(call LINK_RULE,$(TARGET),$(SOURCES),$(LIBS),$(DEPS)))
endif


$(eval $(call NMF_RULE,$(TARGET),))
