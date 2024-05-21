#!/usr/bin/env perl -w

##############################################################################
##### declare uses

## basics to ensure good quality and get good messages in runtime.
use strict;
use warnings;
use diagnostics;
use Carp qw(cluck confess);

use DateTime;
use Time::Piece;
use Getopt::Long qw(:config no_ignore_case);

local $ENV{PERL_LWP_SSL_VERIFY_HOSTNAME} = 0 ;

our $VERSION = '1.0';
my $COMMA                       = q{,};
my $SEMICOLON                   = q{;};
my $EMPTY                       = q{};

# date/time
use vars qw (
	$local_sec
	$local_min
	$local_hour
	$local_day
	$local_month
	$local_year
	$display_local_sec
	$display_local_min
	$display_local_hour
	$display_local_day
	$display_local_month
);

# date/time
($local_sec,$local_min,$local_hour,$local_day,$local_month,$local_year)
	= localtime time
	;
$local_year = $local_year + 1900;
$local_month++;
$display_local_sec	 = ($local_sec	 < 10) ? "0$local_sec"	 : $local_sec;
$display_local_min	 = ($local_min	 < 10) ? "0$local_min"	 : $local_min;
$display_local_hour	 = ($local_hour	 < 10) ? "0$local_hour"	 : $local_hour;
$display_local_day	 = ($local_day	 < 10) ? "0$local_day"	 : $local_day;
$display_local_month = ($local_month < 10) ? "0$local_month" : $local_month;


#############################################################################
##### get options/parameters
my $param_ops   = $EMPTY;
my $param_jours = $EMPTY;
my $param_year  = $EMPTY;
my $param_month = $EMPTY;
my $param_day   = $EMPTY;
my %all_options = (
	'o'  =>\$param_ops,
	'j'  =>\$param_jours,
	'y'  =>\$param_year,
	'm'  =>\$param_month,
	'd'  =>\$param_day,
);
my $options_parse_status = GetOptions(\%all_options,'o=s', 'y=s','m=s','d=s', 'j=s');

$param_year  = ($param_year)  ? $param_year  : $local_year;
$param_month = ($param_month) ? $param_month : $local_month;
$param_day   = ($param_day)   ? $param_day   : $local_day;

my $new_date = $EMPTY;
my $day_of_the_week = Time::Piece->strptime("${param_year}-${param_month}-${param_day}", '%Y-%m-%d');
my $new_day_of_the_week = $EMPTY;

if($param_ops =~ m/^\+$/xmsi) {
	$new_date = DateTime->new( year => $param_year, month => $param_month, day => $param_day )->add( days => $param_jours)->ymd('-');
}
if($param_ops =~ m/^\-$/xmsi) {
	$new_date = DateTime->new( year => $param_year, month => $param_month, day => $param_day )->subtract( days => $param_jours)->ymd('-');
}

$new_date = ($new_date) ? $new_date : "${param_year}-${param_month}-${param_day}";
$new_day_of_the_week = Time::Piece->strptime($new_date, '%Y-%m-%d');
print "\n${param_year}-${param_month}-${param_day} (" . $day_of_the_week->fullday . ") - $param_jours = $new_date (" . $new_day_of_the_week->fullday . ")\n\n";

exit 0;
