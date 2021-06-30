default: sha1.dylib
	/usr/local/opt/sqlite3/bin/sqlite3 -init hashchain.sql

sha1.dylib: sha1.c
	gcc -g -fPIC -I /usr/local/opt/sqlite3/include -dynamiclib sha1.c -o sha1.dylib

# On Linux:

# default: sha1.so
# 	sqlite3 -init hashchain.sql

# sha1.so: sha1.c
# 	gcc -fPIC -lm -shared sha1.c -o sha1.so
