#!/usr/bin/perl

use strict;
use warnings;
use feature 'say';

use Time::Piece;

print "day:\n";
chomp(my $date = <STDIN>);
print "mon:\n";
chomp(my $mon = <STDIN>);
print "year:\n";
chomp(my $year = <STDIN>);

my $tp = Time::Piece->strptime("$year-$mon-$date", '%Y-%m-%d');

say $tp->fullday;
