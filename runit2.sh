#!/bin/bash
#SCORE=fm-xy-nogui.sco
#ORC=fm-xy-nogui.orc
SCORE=harmonics.sco
ORC=harmonics.orc
B=`basename "$1"`
T=`tempfile`
rm -f $T
P=`pwd`
mkdir $T
ln -s $P/$SCORE $P/$ORC $P/Makefile $P/json-stats.pl $P/score.R $P/VideoGen.cpp $P/Video-Gen $T/ &&
cp "$1" $T/infile.avi && \
pushd $T && \
make render.webm
mv render.webm "$P/$B.render.webm"
popd
echo rm -rf $T
