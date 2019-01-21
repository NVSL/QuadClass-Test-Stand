
PARTS=new_big_brace.scad new_side.scad
SVGS=$(PARTS:%.scad=%.svg)
PDFS=$(PARTS:%.scad=%.pdf)
DXFS=$(PARTS:%.scad=%.dxf)

.PHONY: default
default: $(SVGS) $(PDFS)
dxf: $(DXFS)

new_big_brace.scad new_side.scad: new_stand.py
	python new_stand.py

%.scad: %.py
	python $< > $@

%.svg: %.scad
	/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD $< -o $@
	cp $@ $@.tmp; perl -ne 's/width="(\d+(\.\d+)?)"/width="$$1mm"/; s/height="(\d+(\.\d+)?)"/height=\"$$1mm\"/g; s/fill=".*"/fill="none" stroke-width="0.1"/g; print' < $@.tmp > $@; rm $@.tmp;

%.dxf: %.scad
	/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD $< -o $@

%.pdf: %.svg
	inkscape --export-pdf="$$PWD/$@" "$$PWD/$<"


clean:
	rm -rf $(SVGS) $(PDFS)
