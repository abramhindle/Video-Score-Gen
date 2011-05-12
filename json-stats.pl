use JSON;
use strict;
my $txt = "";
{
    local $/=undef;
    $txt = <>;
}
my $arr  = decode_json $txt;
my $first = 1;
foreach my $entry (@$arr) {
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
    if ($first) {
        $first=!$first;
        my ($spc,$cen,$huc,$red,$green,$blue) = map { 0 } (0..10);
        print join(",","frame","fps",
                   "mean",
                   "std",
                   "meandiff",
                   "stddiff",
                   (map { "spacial".$spc++ } @spacial),
                   (map { "central".$cen++ } @central),
                   (map { "hu".$huc++ } @hu),
                   (map { "red".$red++ } @red),
                   (map { "green".$green++ } @green),
                   (map { "blue".$blue++ } @blue),
                   "nsift",
                   "nsurf").$/;
    }
    print join(",", $frame,$fps, 
               $mean,$std,$meandiff,$stddiff,
               @spacial, @central, @hu, @red, @green, @blue, $nsift, $nsurf),$/
;
}
