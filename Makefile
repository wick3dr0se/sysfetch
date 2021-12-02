all:
	echo Run \'sudo make install\' to install sysfetch.
	echo to remove instead run: \'sudo make uninstall\'.

install:
	mkdir -p /usr/lib/sysfetch/components
	mkdir -p /usr/share/man/man1
	ln -s /usr/lib/sysfetch/sysfetch /usr/bin/sysfetch
	cp -p sysfetch /usr/lib/sysfetch
	cp -R -p components /usr/lib/sysfetch/
	cp -p sysfetch.1 /usr/share/man/man1
	cp -p License.md /usr/lib/sysfetch/License
	chmod 755 /usr/lib/sysfetch/sysfetch

uninstall:
	rm /usr/bin/sysfetch
	rm -rf /usr/lib/sysfetch
	rm -rf /usr/share/man/man1/sysfetch.1*
