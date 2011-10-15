use JSON;
use v5.10;
use List::Util qw(shuffle);
use strict;
my $txt = "";
{
    local $/=undef;
    $txt = <>;
}
my $arr  = decode_json $txt;
my $first = 1;
foreach my $entry (@$arr) {
    my $width    = $entry->{width};
    my $height    = $entry->{height};
    my $frame    = $entry->{frame};
    my $fps      = $entry->{FPS};
    my $mean     = $entry->{mean};
    my $std      = $entry->{std};
    my $meandiff = $entry->{meandiff};
    my $stddiff  = $entry->{stddiff};
    my @spacial  = @{ $entry->{"spacial-moments"} };
    my @central  = @{ $entry->{"central-moments"} };
    my @hu       = @{ $entry->{hu} };
    my @red      = @{ $entry->{"red-hist"}};
    my @green    = @{ $entry->{"green-hist"}};
    my @blue     = @{ $entry->{"blue-hist"}};
    my $nsift    = $entry->{SIFT}->{nkeypoints} ;
    my $nsurf    = $entry->{SURF}->{nkeypoints} ;    
    my @lines    = @{$entry->{lines}};
    @lines = @lines[0..9];
    my $dur = 1.0 / $fps;
    my $time = $dur * $first;

   foreach my $line (@lines) {
	next unless ref($line);
	my ($x1,$y1,$x2,$y2) = @$line;
	my $angle = atan2($x2 - $x1,$y2 - $y1);
	my $mag = sqrt(($x2 - $x1)**2 + ($y2 - $y1)**2);
	say("i\"Line\" ".join(" ",map {sprintf('%0.6f',$_)} ($time,$dur,$mag,$angle,$x1,$y1,$x2,$y2)));
   }

    $first++; 
}
