use strict;
use warnings;
use Test::More;

# Ensure a recent version of Test::Pod::Coverage
my $min_tpc = 1.08;
eval "use Test::Pod::Coverage $min_tpc";
plan skip_all => "Test::Pod::Coverage $min_tpc required for testing POD coverage"
    if $@;

# Test::Pod::Coverage doesn't require a minimum Pod::Coverage version,
# but older versions don't recognize some common documentation styles
my $min_pc = 0.18;
eval "use Pod::Coverage $min_pc";
plan skip_all => "Pod::Coverage $min_pc required for testing POD coverage"
    if $@;


my $_internal_functions = [
                            'AddValue', 
                            'BuildPoints', 
                            'ComputeAreaExtrema', 
                            'ComputeAreaExtrema_double', 
                            'ComputeAreaExtrema_float', 
                            'GetDistanceFunctionType', 
                            'GetIndices', 
                            'GetIntLat', 
                            'GetIntLatLon', 
                            'GetIntLon', 
                            'GetLowLevelCodeType', 
                            'GetSupportedLowLevelCodeTypes', 
                            'GetValue', 
                            'HaversineDistance', 
                            'HaversineDistance_double', 
                            'HaversineDistance_float', 
                            'LongitudeCircumference', 
                            'OneDegreeInMeters', 
                            'OneMeterInDegrees', 
                            'SetDistanceFunctionType', 
                            'SetUpDistance_double', 
                            'SetUpDistance_float', 
                            'fast_log2', 
                            'fast_log2_double', 
                            'fast_log2_float', 
                            'log2'
                          ];

all_pod_coverage_ok( { trustme=>$_internal_functions } );

