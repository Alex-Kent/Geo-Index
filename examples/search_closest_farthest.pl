#!/usr/bin/perl

$|=0; # Unbuffer STDOUT

use Geo::Index;

my $_points = LoadPoints();

my $index = Geo::Index->new( { levels=>20 } );
$index->IndexPoints( $_points );

print "Benchmarking Search(...), Closest(...), and Farthest(...) for all points\n\n";
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


sub LoadPoints() {
	my @points = ();
	
	open IN, "cities.txt";
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
