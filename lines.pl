use JSON;
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
    my $time = 1.0* $first/$fps;
    
    $first++; 
}
