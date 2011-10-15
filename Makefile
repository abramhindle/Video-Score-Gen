THISPATH=.
#SCORE=fm-xy-nogui.sco
#ORC=fm-xy-nogui.orc
SCORE=harmonics.sco
ORC=harmonics.orc
OPENCV=-lopencv_calib3d -lopencv_contrib -lopencv_core -lopencv_features2d -lopencv_flann -lopencv_gpu -lopencv_highgui -lopencv_imgproc -lopencv_legacy -lopencv_ml -lopencv_objdetect -lopencv_video 
PERL=/usr/bin/perl
RSCRIPT=/usr/bin/Rscript
CAT=/bin/cat
CSOUND=/usr/bin/csound
FFMPEG=/usr/bin/ffmpeg
MPLAYER=/usr/bin/mplayer
play: render.avi
	$(MPLAYER) -ni -idx render.avi

Video-Gen: 	VideoGen.cpp
	g++ -I /usr/local/include/opencv -lm $(OPENCV) VideoGen.cpp -o Video-Gen   

VideoLines: 	VideoLines.cpp
	g++ -I /usr/local/include/opencv -lm $(OPENCV) VideoLines.cpp -o VideoLines

infile.json: Video-Gen infile.avi
	$(THISPATH)/Video-Gen > infile.json

videolines.json: VideoLines infile.avi
	$(THISPATH)/VideoLines > videolines.json

vl.sco: videolines.json lines.pl
	perl lines.pl videolines.json > vl.sco

linesrender.sco: $(SCORE) $(ORC) vl.sco
	$(CAT) $(THISPATH)/$(SCORE) vl.sco > linesrender.sco
linesrender.wav: $(ORC) vl.sco linesrender.sco
	$(CSOUND) -dm6 -o linesrender.wav $(ORC) linesrender.sco 
linesrender.avi: linesrender.wav infile.avi
	$(FFMPEG) -y -i infile.avi -i linesrender.wav  -map 0.0:1 -map 1:0 -f avi -vcodec copy -acodec copy linesrender.avi

video.csv:	infile.json json-stats.pl
	$(PERL) $(THISPATH)/json-stats.pl < infile.json > video.csv

score.sco: score.R video.csv
	$(RSCRIPT) $(THISPATH)/score.R > score.sco

render.sco: $(SCORE) $(ORC) score.sco
	$(CAT) $(THISPATH)/$(SCORE) score.sco > render.sco

render.wav: render.sco $(ORC)
	$(CSOUND) -dm6 -o render.wav $(ORC) render.sco 

render.avi: render.wav infile.avi
	$(FFMPEG) -y -i infile.avi -i render.wav  -map 0.0:1 -map 1:0 -f avi -vcodec copy -acodec copy render.avi

render.ogv: render.avi
	/usr/bin/ffmpeg2theora -v 3 -a 10 render.avi

render.mp4: render.avi
	ffmpeg -i render.avi -vcodec libx264 -vpre slow -crf 22 -threads 0 render.mp4
render.webm: render.avi
	mencoder render.avi -idx -ovc copy -oac copy -o render.clean.avi || ln render.avi render.clean.avi
	ffmpeg -y -i render.clean.avi -threads 0 -f webm -vcodec libvpx -deinterlace -g 120 -level 216 -profile 0 -qmax 42 -qmin 10 -rc_buf_aggressivity 0.95 -vb 2M -acodec libvorbis -aq 90 -ac 1 render.webm
	rm render.clean.avi

current.avi: vl.sco
	mencoder mf://current*.png -mf w=640:h=480:fps=30:type=png -ovc lavc -lavcopts vcodec=mpeg4:mbd=2:trell -oac copy -o current.avi
linecurrentrender.avi: linesrender.wav infile.avi current.avi
	$(FFMPEG) -y -i current.avi -i linesrender.wav  -map 0.0:1 -map 1:0 -f avi -vcodec copy -acodec copy linecurrentrender.avi
