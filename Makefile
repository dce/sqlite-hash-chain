default: sha1.dylib
	/usr/local/opt/sqlite3/bin/sqlite3 -init hashchain.sql

sha1.dylib: sha1.c
	gcc -g -fPIC -I /usr/local/opt/sqlite3/include -dynamiclib sha1.c -o sha1.dylib
