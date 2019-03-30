use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Geo::Index',
    AUTHOR              => q{Alex Kent Hajnal <akh@cpan.org>},
    VERSION_FROM        => 'lib/Geo/Index.pm',
    ABSTRACT_FROM       => 'lib/Geo/Index.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Geo-Index-*' },
);
