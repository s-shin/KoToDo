use ExtUtils::MakeMaker;

WriteMakefile(
    NAME          => 'KoToDo',
    VERSION_FROM  => 'lib/KoToDo.pm',
    PREREQ_PM     => {
        'Kossy' =>  '0.19',
    },
    MIN_PERL_VERSION => '5.008001'
);

