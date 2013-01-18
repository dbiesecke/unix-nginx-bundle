** Installiert nginx mit diversen modulen


INSTALL

		* Search for Libarys and creates Makefile
		./configure --user=www-data --group=www-data --prefix=/usr/local/nginx/ --sbin-path=/usr/local/sbin \
			--with-http_perl_module \
			--add-module=./bundle/ngx_http_auth_request_module/

		make &&  sudo make install

PERSISTENT

		wget -c 'http://wiki.nginx.org/index.php?title=Nginx-init-ubuntu&action=raw&anchor=nginx' -O /etc/init.d/nginx && chmod +x /etc/init.d/nginx
		sudo update-rc.d nginx defaults
		sudo /etc/init.d/nginx start
 
