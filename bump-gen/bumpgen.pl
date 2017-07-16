#!/usr/bin/perl -w
use strict;
use GD;
use Data::Dumper;

$|=1;
my $counter = 0;
my @instructions;
my $instruct;
my $im;

open(CFG, "silence.cfg");
while (my $aline = <CFG>) {
	chomp $aline;
	if ($aline =~ "main") {
		eval("push(\@instructions, {$aline})");
	}
}
close(CFG);

system('rm -f *.jpg');

foreach $instruct (@instructions) {
	$im = new GD::Image(640,480);
	$im->fill(0,0,$im->colorAllocate(0,0,0));

	&putmaintext($im, $instruct->{'main'}, 'center');
	&putminitexts($im, $instruct->{'mini'}, 'right') if (defined $instruct->{'mini'});

	print "$instruct->{'main'}";
	for(my $x=0;$x<($instruct->{'length'}*4);$x++) {
		open(IMG, sprintf(">%04d.jpg", $counter));
		binmode IMG;
		print IMG $im->jpeg;
		close(IMG);
		print ".";
		$counter++;
	}
	print "\n";
}

system('mencoder "mf://*.jpg" -mf fps=4 -o file.avi -ovc lavc -lavcopts vcodec=mpeg4 -oac copy -audiofile "/media/misc/streams/Anuraag - Indian Classical Music Selections/all.mp3" -delay 55');
system('rm -f *.jpg');

sub sizeof {
	my ($text, $ptsize) = @_;
	my $im = new GD::Image(640,480);
	my @bounds = $im->stringFT($im->colorAllocate(255,255,255), './HelveticaNeueCondensedBold.ttf',$ptsize,0,0,0,$text);
	#return ($bounds[2]-$bounds[0], $bounds[5] + $bounds[3] + $ptsize);
	return ($bounds[2]-$bounds[0], $ptsize);
}

sub putmaintext {
	my ($im, $text, $align) = @_;
	if ($text =~ "\n") {
		my @temp = split("\n", $text);
		&putmaintexts($im, $temp[0] . "\n ", $align);
		&putmaintexts($im, "\n" . $temp[1], $align);
	}
	else {
		&putmaintexts($im, $text, $align);
	}
}

sub putmaintexts {
	my ($im, $text, $align) = @_;
	my @size = sizeof($text, 40);
	my ($x, $y);
	if ($align eq "center") {
		$x = (640/2-($size[0]/2));
		$y = (480/2-($size[1]/2));
	}
	$im->stringFT($im->colorAllocate(255,255,255), './HelveticaNeueCondensedBold.ttf',40,0,$x,$y,$text);
}

sub putminitexts {
	my ($im, $text, $align) = @_;
	my @size = sizeof($text, 18);
	my $x = (620-$size[0]);
	my $y = (470-$size[1]);
	print "Width: $size[0] Height: $size[1] x: $x y: $y\n";
	$im->stringFT($im->colorAllocate(255,255,255), './HelveticaNeueCondensedBold.ttf',18,0,$x,$y,$text);
}
