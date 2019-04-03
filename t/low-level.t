#!perl

# Test swappable low-level functions
# (Perl, C float, and C double)

use constant test_count => 14;

use strict;
use warnings;
use Test::More tests => test_count;
use Config;

use_ok( 'Geo::Index' );

# Create and populate index
my $index = Geo::Index->new( { levels=>20 } );
isa_ok $index, 'Geo::Index', 'Geo::Index object';

# Determine what type of key we expect to have
my $expecting_numeric_keys = ( $Config{use64bitint} ) ? 1 : 0;

# Determine what type of keys we actually have
my %config = $index->GetConfiguration();
my $have_numeric_keys = ( ( $config{key_type} eq 'numeric' ) || ( $config{key_type} eq 'packed' ) ) ? 1 : 0;

# See whether our expectations are met
cmp_ok( $have_numeric_keys, '==', $expecting_numeric_keys, "Key type is sensible" );

my @points = (
               { lat=>78.666667, lon=>16.333333, name=>'Svalbard, Norway' },
               { lat=>52.30,     lon=>13.25,     name=>'Berlin, Germany' }
             );

SKIP: {
	# Create new index
	my $index = Geo::Index->new();
	
	# Find out what code types it supports
	my $_types = $index->GetSupportedLowLevelCodeTypes();
	
	# Skip tests if we don't have C code
	
	if ( scalar(@$_types) == 0 ) {
		fail "No low-level code available, WTF?";
		skip "Couldn't determine available low-level code types", test_count - 2;
		
	} elsif ( scalar(@$_types) == 1 ) {
		skip "Accelerated C code not available", test_count - 3;
	}
	
	# Set up points for test
	my @points = (
	               { lat=>78.666667, lon=>16.333333, name=>'Svalbard, Norway' },
	               { lat=>52.30,     lon=>13.25,     name=>'Berlin, Germany' }
	             );
	
	my $_results;
	
	# Check default methods and functions
	
	# Index using default code type
	$index->IndexPoints( \@points );
	
	# Check distance code
	my $distance = int $index->Distance( @points );
	cmp_ok( $distance, 'eq', 2934440, "Distance, default" );
	
	# Check search code
	$_results = $index->Search( $points[1] );
	is_deeply( $_results, [ $points[0], $points[1] ], "Search, default" );
	
	# Loop through all available code types...
	foreach my $type ( @$_types ) {
		
		# Create and populate index using specific low-level code type
		my $index = Geo::Index->new( { function_type => $type } );
		$index->IndexPoints( \@points );
		
		# See if we got the code type we asked for
		my $type_in_use = $index->GetLowLevelCodeType();
		cmp_ok( $type_in_use, 'eq', $type, "Type in use is type requested ($type)" );
		
		# Check distance code
		my $distance = int $index->Distance( @points );
		cmp_ok( $distance, 'eq', 2934440, "Distance, $type" );
		
		# Check search code
		$_results = $index->Search( $points[1] );
		is_deeply( $_results, [ $points[0], $points[1] ], "Search, $type" );
	}
	
}

done_testing;
