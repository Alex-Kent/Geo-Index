#!/usr/bin/perl

use strict;
use warnings;

use Geo::Index;

sub LoadPoints();
my $_results;


print "Loading points\n";

my $_points = LoadPoints();

my $index = Geo::Index->new( { levels=>20 } );
$index->IndexPoints( $_points );



print "\nRunning normal search (1,000 km radius) around 10 points\n\n";

srand 0;

for (my $i=0; $i<10; $i++) {
	# Choose search point
	my $_point = $$_points[rand(@$_points)];
	print "\t$$_point{name}:\n";
	
	# Run Search
	my $_results = $index->Search( $_point, { sort_results=>1, radius=>1_000_000, pre_condition=>sub { my ($rp, $sp, $d)=@_; return ($rp!=$sp); } } );
	
	# Display results
	foreach my $p1 (@$_results) {
		printf("\t\t$$p1{name}: %i km\n", int($$p1{search_result_distance} / 1000));
	}
	print "\n";
}
print "\n\n";


print "\nRunning quick search (1,000 km radius) around the same 10 points\n\n";

srand 0;

for (my $i=0; $i<10; $i++) {
	# Choose search point
	my $_point = $$_points[rand(@$_points)];
	print "\t$$_point{name}:\n";
	
	# Run Search
	my $_results = $index->Search( $_point, { quick_results=>1, radius=>1_000_000 } );
	
	# Display results
	foreach my $_set (@$_results) {
		next unless (defined $_set);
		foreach my $p1 (@$_set) {
			print "\t\t$$p1{name}\n";
		}
	}
	print "\n";
}
print "\n\n";



print "\nFinding points within 3,000 km of the north pole\n\n";

# Run search
$_results = $index->Search( [ 90, 0 ], { sort_results=>1, radius=>3_000_000 } );

# Display results
foreach my $_point (@$_results) {
	printf("\t$$_point{name}: %i km\n", int($$_point{search_result_distance} / 1000));
}
print "\n";


print "\nFinding points within 3,000 km of the north pole (quick results)\n\n";

# Run search
$_results = $index->Search( [ 90, 0 ], { quick_results=>1, radius=>3_000_000 } );

# Display results
foreach my $_set (@$_results) {
	next unless (defined $_set);
	foreach my $_point (@$_set) {
		print "\t$$_point{name}\n";
	}
}
print "\n";




print "\nFinding points within 5,000 km of the south pole\n\n";

# Run search
$_results = $index->Search( [ -90, 180 ], { sort_results=>1, radius=>5_000_000 } );

# Display results
foreach my $_point (@$_results) {
	printf("\t$$_point{name}: %i km\n", int($$_point{search_result_distance} / 1000));
}
print "\n";


print "\nFinding points within 5,000 km of the south pole (quick results)\n\n";

# Run search
$_results = $index->Search( [ -90, 180 ], { quick_results=>1, radius=>5_000_000 } );

# Display results
foreach my $_set (@$_results) {
	next unless (defined $_set);
	foreach my $_point (@$_set) {
		print "\t$$_point{name}\n";
	}
}
print "\n";





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
