use inc::Module::Install;
name 'Net-Redmine';
all_from 'lib/Net/Redmine.pm';

requires
    "Any::Moose"                    => "0.07",
    "Encode"                        => "2.31",
    "HTML::WikiConverter"           => "0.68",
    "HTML::WikiConverter::Markdown" => "0.05",
    "IO::All"                       => "0.39",
    "WWW::Mechanize"                => "1.52",
    "Text::CSV::Slurp"              => "0.5",
    "IO::String"                    => "1.08",
    "pQuery"                        => "0.07";

build_requires
    "Test::Cukes"             => "0.02",
    "Test::Memory::Cycle"     => "1.04",
    "Text::Greeking"          => "0.11",
    "Quantum::Superpositions" => "1.03",
    "Test::More"              => "0.86";

repository 'http://github.com/gugod/net-redmine';

tests 't/*.t';
author_tests 'xt';

auto_include;
# auto_license;
WriteAll;
