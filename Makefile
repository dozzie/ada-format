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

.PHONY: clean
clean:
	rm -f main *.o *.ali b~*
