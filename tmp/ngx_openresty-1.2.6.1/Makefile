.PHONY: all install clean

all:
	cd /tmp/nginx-catap/tmp/ngx_openresty-1.2.6.1/build/lua-5.1.5 && $(MAKE) linux
	cd /tmp/nginx-catap/tmp/ngx_openresty-1.2.6.1/build/lua-cjson-1.0.3 && $(MAKE) DESTDIR=$(DESTDIR) LUA_INCLUDE_DIR=/tmp/nginx-catap/tmp/ngx_openresty-1.2.6.1/build/lua-root/usr/local/nginx//lua/include LUA_LIB_DIR=/usr/local/nginx//lualib CC=gcc
	cd /tmp/nginx-catap/tmp/ngx_openresty-1.2.6.1/build/lua-redis-parser-0.10 && $(MAKE) DESTDIR=$(DESTDIR) LUA_INCLUDE_DIR=/tmp/nginx-catap/tmp/ngx_openresty-1.2.6.1/build/lua-root/usr/local/nginx//lua/include LUA_LIB_DIR=/usr/local/nginx//lualib CC=gcc
	cd /tmp/nginx-catap/tmp/ngx_openresty-1.2.6.1/build/lua-rds-parser-0.05 && $(MAKE) DESTDIR=$(DESTDIR) LUA_INCLUDE_DIR=/tmp/nginx-catap/tmp/ngx_openresty-1.2.6.1/build/lua-root/usr/local/nginx//lua/include LUA_LIB_DIR=/usr/local/nginx//lualib CC=gcc
	cd /tmp/nginx-catap/tmp/ngx_openresty-1.2.6.1/build/nginx-1.2.6 && $(MAKE)

install: all
	cd /tmp/nginx-catap/tmp/ngx_openresty-1.2.6.1/build/lua-5.1.5 && $(MAKE) install INSTALL_TOP=$(DESTDIR)/usr/local/nginx//lua
	cd /tmp/nginx-catap/tmp/ngx_openresty-1.2.6.1/build/lua-cjson-1.0.3 && $(MAKE) install DESTDIR=$(DESTDIR) LUA_INCLUDE_DIR=/tmp/nginx-catap/tmp/ngx_openresty-1.2.6.1/build/lua-root/usr/local/nginx//lua/include LUA_LIB_DIR=/usr/local/nginx//lualib CC=gcc
	cd /tmp/nginx-catap/tmp/ngx_openresty-1.2.6.1/build/lua-redis-parser-0.10 && $(MAKE) install DESTDIR=$(DESTDIR) LUA_INCLUDE_DIR=/tmp/nginx-catap/tmp/ngx_openresty-1.2.6.1/build/lua-root/usr/local/nginx//lua/include LUA_LIB_DIR=/usr/local/nginx//lualib CC=gcc
	cd /tmp/nginx-catap/tmp/ngx_openresty-1.2.6.1/build/lua-rds-parser-0.05 && $(MAKE) install DESTDIR=$(DESTDIR) LUA_INCLUDE_DIR=/tmp/nginx-catap/tmp/ngx_openresty-1.2.6.1/build/lua-root/usr/local/nginx//lua/include LUA_LIB_DIR=/usr/local/nginx//lualib CC=gcc
	cd /tmp/nginx-catap/tmp/ngx_openresty-1.2.6.1/build/lua-resty-dns-0.09 && $(MAKE) install DESTDIR=$(DESTDIR) LUA_LIB_DIR=/usr/local/nginx//lualib INSTALL=/tmp/nginx-catap/tmp/ngx_openresty-1.2.6.1/build/install
	cd /tmp/nginx-catap/tmp/ngx_openresty-1.2.6.1/build/lua-resty-memcached-0.10 && $(MAKE) install DESTDIR=$(DESTDIR) LUA_LIB_DIR=/usr/local/nginx//lualib INSTALL=/tmp/nginx-catap/tmp/ngx_openresty-1.2.6.1/build/install
	cd /tmp/nginx-catap/tmp/ngx_openresty-1.2.6.1/build/lua-resty-redis-0.15 && $(MAKE) install DESTDIR=$(DESTDIR) LUA_LIB_DIR=/usr/local/nginx//lualib INSTALL=/tmp/nginx-catap/tmp/ngx_openresty-1.2.6.1/build/install
	cd /tmp/nginx-catap/tmp/ngx_openresty-1.2.6.1/build/lua-resty-mysql-0.12 && $(MAKE) install DESTDIR=$(DESTDIR) LUA_LIB_DIR=/usr/local/nginx//lualib INSTALL=/tmp/nginx-catap/tmp/ngx_openresty-1.2.6.1/build/install
	cd /tmp/nginx-catap/tmp/ngx_openresty-1.2.6.1/build/lua-resty-string-0.08 && $(MAKE) install DESTDIR=$(DESTDIR) LUA_LIB_DIR=/usr/local/nginx//lualib INSTALL=/tmp/nginx-catap/tmp/ngx_openresty-1.2.6.1/build/install
	cd /tmp/nginx-catap/tmp/ngx_openresty-1.2.6.1/build/lua-resty-upload-0.06 && $(MAKE) install DESTDIR=$(DESTDIR) LUA_LIB_DIR=/usr/local/nginx//lualib INSTALL=/tmp/nginx-catap/tmp/ngx_openresty-1.2.6.1/build/install
	cd /tmp/nginx-catap/tmp/ngx_openresty-1.2.6.1/build/nginx-1.2.6 && $(MAKE) install DESTDIR=$(DESTDIR)

clean:
	rm -rf build
