#!/usr/bin/perl

# If you want to use the compiled C functions but don't want the build to be 
# done in the current directory, you can specify an alternate build and library 
# directory here.  The example below creates 'build' and 'lib' directories along 
# with a 'config' file in '/tmp/'.  For your own scripts, change '/tmp' as 
# appropriate for your environment.

# Important: The specified directory must exist and be writable before the 
# script is run.

# Important: The following line MUST appear before the "use Geo::Index;" line:
use Inline(Config => DIRECTORY => '/tmp');

# If running in taint mode (i.e. 'perl -T') then uncomment the following line:
#use Inline(Config => ( ENABLE => 'UNTAINT', NO_UNTAINT_WARN => 1 ) );


# Load the module
use Geo::Index;


# Create empty index
my $index = Geo::Index->new( );


# Check that Geo::Index is using C low-level code
my %config = $index->GetConfiguration( );


if ( ( $config{code_type} eq 'float' ) || ( $config{code_type} eq 'double' ) ) {
	print "Success, using C $config{code_type} code\n";
} else {
	print "\nFailed, falling back to using $config{code_type} code\n";
}
