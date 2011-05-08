#!/bin/bash
SCORE=fm-xy-nogui.sco
ORC=fm-xy-nogui.orc
B=`basename $1`
T=`tempfile`
rm -f $T
P=`pwd`
mkdir $T
cp $1 $T/infile.avi && \
pushd $T && \
$P/Video-Gen > infile.json && \
perl $P/json-stats.pl < infile.json > video.csv 
Rscript $P/score.R > score.sco && \
cat $P/fm-xy-nogui.sco score.sco > render.sco && \
cp $P/$ORC ./render.orc && \
csound -dm6 -o render.wav render.orc render.sco  && \
ffmpeg -y -i infile.avi -i render.wav  -map 0.0:1 -map 1:0 -f avi -vcodec copy -acodec copy render.avi
#ffmpeg -y -i infile.avi -i render.wav  -map 0.0:1 -map 1:0 render.webm
mv render.avi "$P/$B.render.avi"
#mv render.webm "$P/$B.render.webm"
popd
echo rm -rf $T



