#!perl -T

use strict;
use warnings;
use Test::More;

unless ( $ENV{RELEASE_TESTING} ) {
    plan( skip_all => "Author tests not required for installation" );
}

eval "use Test::CheckManifest 0.9";
plan skip_all => "Test::CheckManifest 0.9 required" if $@;
ok_manifest( 
             { 
               filter => [ 
                           qr/\/\.git\//, 
                           qr/\/\.gitignore/, 
                           qr/\/Geo-Index-.*\.tar\.gz$/, 
                           qr/\/PAUSE\.*/, 
                           qr/\/Index\.(?:bs|c|o)$/, 
                           qr/\/Makefile\.old$/, 
                           qr/\/examples\/sample.pl$/, 
                           qr/\/README.place_names$/ 
                         ]
             }
           );
