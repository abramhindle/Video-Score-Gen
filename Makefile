THISPATH=.
SCORE=fm-xy-nogui.sco
ORC=fm-xy-nogui.orc
OPENCV=-lopencv_calib3d -lopencv_contrib -lopencv_core -lopencv_features2d -lopencv_flann -lopencv_gpu -lopencv_highgui -lopencv_imgproc -lopencv_legacy -lopencv_ml -lopencv_objdetect -lopencv_video 
PERL=/usr/bin/perl
RSCRIPT=/usr/bin/Rscript
CAT=/bin/cat
CSOUND=/usr/bin/csound
FFMPEG=/usr/bin/ffmpeg

play: render.avi
	mplayer render.avi

Video-Gen: 	VideoGen.cpp
	g++ -I /usr/local/include/opencv -lm $(OPENCV) VideoGen.cpp -o Video-Gen   

infile.json: Video-Gen infile.avi
	$(THISPATH)/Video-Gen > infile.json

video.csv:	infile.json json-stats.pl
	$(PERL) $(THISPATH)/json-stats.pl < infile.json > video.csv

score.sco: score.R video.csv
	$(RSCRIPT) $(THISPATH)/score.R > score.sco

render.sco: $(SCO) $(ORC) score.sco
	$(CAT) $(THISPATH)/fm-xy-nogui.sco score.sco > render.sco

render.wav: render.sco $(ORC)
	$(CSOUND) -dm6 -o render.wav $(ORC) render.sco 

render.avi: render.wav infile.avi
	$(FFMPEG) -y -i infile.avi -i render.wav  -map 0.0:1 -map 1:0 -f avi -vcodec copy -acodec copy render.avi

