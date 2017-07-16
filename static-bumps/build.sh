#!/bin/sh
for f in 1 2 3 4 5 6 7 8 9 10
do
	cp images/${1}.jpg frame${f}.jpg
done
mencoder "mf://*.jpg" -mf fps=1 -o bumps/${1}.avi -ovc lavc -lavcopts vcodec=mpeg4 -oac copy -audiofile `random-file ~/wget/www.bumpworthy.com/mp3/`
rm frame*.jpg
