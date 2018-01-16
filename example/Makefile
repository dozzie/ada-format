#!/usr/bin/make -f
#
#-----------------------------------------------------------------------------

.PHONY: all
all: main

main: main.adb example.gpr
	gnatmake -P $(filter %.gpr,$^)

clean:
	rm -f main *.o *.ali b~*

#-----------------------------------------------------------------------------
# vim:ft=make:noet
