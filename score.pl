while(<>) {
    if (/^Hu: (.*)\s*$/) {
        my @v = split(/\s+/, $1);
        print join("\t",@v).$/;
    }
}
