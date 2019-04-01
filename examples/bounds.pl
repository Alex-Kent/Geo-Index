#!/usr/bin/perl

use strict;
use warnings;

use Geo::Index;

sub LoadPoints();
my $_results;


my $_points = LoadPoints();

my $index = Geo::Index->new( { levels=>20 } );
$index->IndexPoints( $_points );


print "Testing bounding boxes roughly covering areas:\n\n";

#.Test the limits
my %bad_lats     = ( north=>-20.0,    west=>-180.0,     south=>20.0,      east=>180.0     );  # Invalid: south > north
my %out_of_range = ( north=>91.0,     west=>-181.0,     south=>-91.0,     east=>181.0     );  # Invalid: all extrema out of bounds
my %max_range    = ( north=>90.0,     west=>-180.0,     south=>-90.0,     east=>180.0     );  # Entire planet

#.Various regions
my %europe       = ( north=>66.58322, west=>-25.13672,  south=>36.17336,  east=>36.71631  );  # lat > 0, lon > 0
my %carribean    = ( north=>28.00410, west=>-86.24268,  south=>9.88769,   east=>-59.07898 );  # lat > 0, lon < 0
my %africa       = ( north=>37.85751, west=>-18.41309,  south=>-34.92197, east=>54.53613  );  # straddles equator and prime meridian
my %aus_nz       = ( north=>-9.53575, west=>112.14844,  south=>-47.29413, east=>-176.0    );  # lat < 0, straddles antimeridian
my %antarctica   = ( north=>-60.0,    west=>-180.0,     south=>-90.0,     east=>180.0     );  # south polar region
my %arctic       = ( north=>90.0,     west=>-180.0,     south=>60.0,      east=>180.0     );  # north polar region


my %options;
#%options = ( condition => sub { my ($p, $b, $u)=@_; return ( $$p{name} =~ /^[A-M]/ ); } );  # Only points starting with the letters A through M
%options = ( );




print "\tBad latitudes (will fail):\n";
$_results = $index->SearchByBounds( \%bad_lats, \%options );
if (defined $_results) {
	foreach my $p (sort { $$a{name} cmp $$b{name} } @$_results) {
		print "\t\t$$p{name}\n";
	}
}
print "\n";



print "\tOut of range (will fail):\n";
$_results = $index->SearchByBounds( \%out_of_range, \%options );
if (defined $_results) {
	foreach my $p (sort { $$a{name} cmp $$b{name} } @$_results) {
		print "\t\t$$p{name}\n";
	}
}
print "\n";



print "\tMax range (all points on globe):\n";
$_results = $index->SearchByBounds( \%max_range, \%options );
if (defined $_results) {
	foreach my $p (sort { $$a{name} cmp $$b{name} } @$_results) {
		print "\t\t$$p{name}\n";
	}
}
print "\n";



print "\tEurope:\n";
$_results = $index->SearchByBounds( \%europe, \%options );
if (defined $_results) {
	foreach my $p (sort { $$a{name} cmp $$b{name} } @$_results) {
		print "\t\t$$p{name}\n";
	}
	print "\n";
}



print "\tCaribbean:\n";
$_results = $index->SearchByBounds( \%carribean, \%options );
if (defined $_results) {
	foreach my $p (sort { $$a{name} cmp $$b{name} } @$_results) {
		print "\t\t$$p{name}\n";
	}
	print "\n";
}



print "\tAfrica:\n";
$_results = $index->SearchByBounds( \%africa, \%options );
if (defined $_results) {
	foreach my $p (sort { $$a{name} cmp $$b{name} } @$_results) {
		print "\t\t$$p{name}\n";
	}
	print "\n";
}



print "\tAustralia and New Zealand:\n";
$_results = $index->SearchByBounds( \%aus_nz, \%options );
if (defined $_results) {
	foreach my $p (sort { $$a{name} cmp $$b{name} } @$_results) {
		print "\t\t$$p{name}\n";
	}
	print "\n";
}



print "\tAntarctica:\n";
$_results = $index->SearchByBounds( \%antarctica, \%options );
if (defined $_results) {
	foreach my $p (sort { $$a{name} cmp $$b{name} } @$_results) {
		print "\t\t$$p{name}\n";
	}
	print "\n";
}



print "\tArctic:\n";
$_results = $index->SearchByBounds( \%arctic, \%options );
if (defined $_results) {
	foreach my $p (sort { $$a{name} cmp $$b{name} } @$_results) {
		print "\t\t$$p{name}\n";
	}
	print "\n";
}






use File::Spec;
use File::Basename;
use Cwd;

sub LoadPoints() {
	my @points = ();
	
	# Determine sample data's filename
	my $file = File::Spec->catdir(
	             File::Basename::dirname( Cwd::abs_path($0) ),
	             'cities.txt'
	           );
	
	unless ( -e $file ) {
		print STDERR "Data file '$file' not found.\n";
		exit;
	}
	
	# Load the sample data
	open IN, $file;
	while (my $line = <IN>) {
		chomp $line;
		my ($country, $city, $lat, $lon) = split /\t/, $line;
		$country =~ s/\s+$//;
		$country =~ s/^\s+//;
		$city =~ s/^\s+//;
		$city =~ s/\s+$//;
		push @points, { lat=>$lat, lon=>$lon, name=>($city) ? "$city, $country" : $country };
	}
	close IN;
	
	return \@points;
}
