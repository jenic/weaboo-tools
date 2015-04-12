#!/usr/bin/perl
use strict;

my @files = ( @ARGV ) ? @ARGV : <STDIN>;
for (@files) {
    chomp();
    if(/\[.*?\]\s?([A-z0-9!\s-]+)\s-\s?/) {
        my $dir = $1;
        mkdir($dir) if(! -e $dir);
        if (/.*(_|\s)(\d+)v?\d?\1.*\.([A-z0-9]+)$/) {
            rename $_, "$dir/$2.$3" unless (-e "$dir/$2.$3");
        } else {
            rename $_, "$dir/$_"
        }
    }
}
