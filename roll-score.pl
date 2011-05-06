use List::Util qw(sum);
my $fps = 30.0;
open(FILE,"roll");
while(<FILE>) {
    chomp;
    my ($time,$b) = split(/\s+/,$_);
    #warn $time;
    $time =~ s/\"//g;
    #warn $time;
    my $t = sp($time / $fps);
    my $d = sp(1.1*1/$fps);
    my $min = 0.001259;
    my $max = 0.021694;
    my $freq = 20 + 1000 * ($b - $min) / ($max - $min);
    print "i1 $t $d 10000 $freq$/";
}
close(FILE);


open(FILE,"moments");
my $time = 1;
while(<FILE>) {
    chomp;
    my @moments = split(/\s+/,$_);
    #warn $time;
    #warn $time;
    my $b = sum(@moments);
    my $t = sp($time / $fps);
    my $d = sp(1.1*1/$fps);
    my $min = 0.001259;
    my $max = 0.021694;
    my $freq = 20 + 1000 * ($b - $min) / ($max - $min) + 100*$b[1] + 1000*$b[2];
    print "i2 $t $d 1000 $freq$/";
    $time++;
}
close(FILE);


sub sp {
    return sprintf('%0.6f',$_[0]);   
}
