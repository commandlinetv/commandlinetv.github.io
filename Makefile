# Makefile -- automate some of the video processing
# Usage: make -j NUM=4 FILE=~/tmp/Ep04-final.mp4

NNN=$(shell printf "%03d" $(NUM))
FFOPTS = -t 30 -y -strict -2 -threads 3 -b:v 400k
MEDIA = $(addprefix _vid/episode$(NNN)., jpg mp4 webm)
DEST = s3://commandline.tv/media/

default: episode$(NNN)/episode$(NNN).html $(MEDIA)
	s3cmd put -P $(MEDIA) $(DEST)

_vid/%.jpg: %overlay.png
	convert $< $@

episode$(NNN)overlay.svg: snap$(NNN).png poster-overlay.svg
	sed -e 's/JJJ/$(NNN)/' -e 's/JJ/$(NUM)/' poster-overlay.svg >$@

%.png: %.svg
	inkscape -C -e $@ $<

_vid/%.mp4: $(FILE)
	@if [ ! -f "$(wildcard $(FILE))" ]; then echo "set FILE=blah.mp4" && false; fi
	@if [ "$(suffix $(FILE))" != ".mp4" ]; then echo "set FILE=foo.mp4" && false; fi
	ffmpeg -i $(FILE) $(FFOPTS) -acodec copy -vcodec libx264 $@

_vid/%.webm: $(FILE)
	@if [ ! -f "$(wildcard $(FILE))" ]; then echo "set FILE=blah.mp4" && false; fi
	@if [ "$(suffix $(FILE))" != ".mp4" ]; then echo "set FILE=foo.mp4" && false; fi
	ffmpeg -i $(FILE) $(FFOPTS) -acodec vorbis -vcodec vp8 $@

episode$(NNN)/episode$(NNN).html:
	rake episode num=$(NUM)
