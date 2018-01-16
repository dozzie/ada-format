#!/usr/bin/make -f

CGNAT = gnatgcc -gnatwa
GNATBIND = gnatbind -static
GNATLINK = gnatlink -g

main: main.o format.o
	$(GNATBIND) $@
	$(GNATLINK) $@

%.o: %.adb
	$(CGNAT) -c $<

main.o: format.ads
format.o: format.ads

#-----------------------------------------------------------------------------

.PHONY: lib
lib: libformat.a format.ali

format.ali: format.o

libformat.a: format.o
	ar rc $@ $^

#-----------------------------------------------------------------------------

.PHONY: clean
clean:
	rm -f main lib*.a lib*.so *.o *.ali b~*
