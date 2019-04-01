#!/usr/bin/perl

use strict;
use warnings;

use Geo::Index;

sub LoadPoints();


my $_points = LoadPoints();

my $index = Geo::Index->new( { levels=>20 } );
$index->IndexPoints( $_points );

print "Running Search(...), Closest(...), and Farthest(...) for all points\n\n";
foreach my $point ( sort { $$a{name} cmp $$b{name} } @$_points ) {
	my $_results;
	
	print "Search(...):\n";
	$_results = $index->Search( $point, { sort_results=>1, max_results=>0, radius=>Geo::Index::ALL, pre_condition=>sub { my ($rp, $sp, $d)=@_; return ($rp!=$sp); } } );
	printf( "Got %i result%s\n", scalar @$_results, (scalar(@$_results) > 1) ? 's' : '' );
	printf( "% 60s  |  %s (%i km)\n", $$point{name}, "$$_results[0]{name}:", int($$_results[0]{search_result_distance} / 1000) );
	printf( "% 60s  |  %s (%i km)\n", $$point{name}, "$$_results[-1]{name}:", int($$_results[-1]{search_result_distance} / 1000) );
	
	print "Closest(...):\n";
	$_results = $index->Closest( $point );
	printf( "Got %i result%s\n", scalar @$_results, (scalar(@$_results) > 1) ? 's' : '' );
	printf( "% 60s  |  %s (%i km)\n", $$point{name}, "$$_results[0]{name}:", int($$_results[0]{search_result_distance} / 1000) );
	
	print "Farthest(...):\n";
	$_results = $index->Farthest( $point );
	printf( "Got %i result%s\n", scalar @$_results, (scalar(@$_results) > 1) ? 's' : '' );
	printf( "% 60s  |  %s (%i km)\n", $$point{name}, "$$_results[0]{name}:", int($$_results[0]{search_result_distance} / 1000) );
	
	print "\n\n".('-'x125)."\n\n";
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
