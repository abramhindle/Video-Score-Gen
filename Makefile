OPENCV=-lopencv_calib3d -lopencv_contrib -lopencv_core -lopencv_features2d -lopencv_flann -lopencv_gpu -lopencv_highgui -lopencv_imgproc -lopencv_legacy -lopencv_ml -lopencv_objdetect -lopencv_video 

play:	render.avi
	mplayer render.avi

Video-Gen: 	VideoGen.cpp
	g++ -I /usr/local/include/opencv -lm $(OPENCV) VideoGen.cpp -o Video-Gen   

fuck: 	fuck.cpp
	g++ -I /usr/local/include/opencv -lm -lcv -lopencv_highgui -lcvaux fuck.cpp -o fuck   

video.out: Video-Gen infile.avi
	./Video-Gen | tee video.out

moments: score.pl video.out
	perl score.pl video.out > moments

run:	Video-Gen infile.avi render.sco

render.sco: roll-score.pl sine.sco roll moments
	(cat sine.sco ; perl roll-score.pl roll ) > render.sco

render.wav: render.sco
	csound -dm6 -o render.wav sine2.orc render.sco 

roll:	moments roll.R
	sh run-r roll.R

render.avi: render.wav infile.avi
	mencoder -ovc copy -oac copy infile.avi -audiofile render.wav -o render.avi
