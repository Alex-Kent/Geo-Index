#!/usr/bin/perl

use strict;
use warnings;

use Geo::Index;

sub LoadPoints();



# Load sample points
my $_points = LoadPoints();

# Create and populate index
my $index = Geo::Index->new( { levels=>20 } );
$index->IndexPoints( $_points );


# Get index's current configuration
my %config = $index->GetConfiguration();

print "Running configuration:\n\n";

# Custom labels for particular keys
my %key_map = ( 'size' => 'Indexed points' );

# Loop through configuration keys in a set order...
foreach my $key ( qw( levels size ), 
                  undef,
                  qw( key_type code_type supported_key_types supported_code_types ), 
                  undef,
                  qw( planetary_radius ), 
                  keys %config ) {
	
	unless ( defined $key ) {
		# Just show a blank line
		print "\n";
		next;
	}
	next unless (defined $config{$key});
	
	# Get value an remove entry from hash
	my $value = $config{$key};
	delete $config{$key};
	
	# Pretty print the key
	my $label = ( defined $key_map{$key} ) ? $key_map{$key} : ucfirst $key;
	$label =~ s/_/ /g;
	
	# Join list values (if applicable)
	$value = join( ", ", @$value) if ( ref $value eq 'ARRAY' );
	
	# Add units to values (if applicable)
	$value .= ' meters' if ( $key =~ /_(radius|circumference)$/ );
	
	# Display the configuration line
	printf( "%30s: %s\n", $label, $value );
}



print "\n\n";


my @stats = $index->GetStatistics();

print "Index statistics:\n\n";

print "                               Number of points per tile:   \n";
print "Level  Points     Tiles     Minimum   Maximum        Average\n";
print "-----  --------   --------  --------  --------  ------------\n";
foreach my $row ( @stats ) {
	$$row{level}           = 'unknown' unless ( defined $$row{level} );
	$$row{points}          = 'unknown' unless ( defined $$row{points} );
	$$row{tiles}           = 'unknown' unless ( defined $$row{tiles} );
	$$row{min_tile_points} = 'unknown' unless ( defined $$row{min_tile_points} );
	$$row{max_tile_points} = 'unknown' unless ( defined $$row{max_tile_points} );
	$$row{avg_tile_points} = 'unknown' unless ( defined $$row{avg_tile_points} );
	printf( " %2i    %-8i   % -8i  %-8i  %-8i  %12.2f\n", $$row{level}, $$row{points}, $$row{tiles}, $$row{min_tile_points}, $$row{max_tile_points}, $$row{avg_tile_points} );
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
