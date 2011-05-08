#!/bin/bash
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
cat $P/sine.sco score.sco > render.sco && \
cp $P/sine2.orc ./render.orc && \
csound -dm6 -o render.wav render.orc render.sco  && \
ffmpeg -y -i infile.avi -i render.wav  -map 0.0:1 -map 1:0 -f avi -vcodec copy -acodec copy render.avi
mv render.avi "$P/$B.render.avi"
popd
echo rm -rf $T



