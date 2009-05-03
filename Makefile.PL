use inc::Module::Install;
name 'Net-Redmine';
all_from 'lib/Net/Redmine.pm';

requires
    "Any::Moose"                    => "0.07",
    "HTML::WikiConverter"           => "0.68",
    "HTML::WikiConverter::Markdown" => "0.05",
    "IO::All"                       => "0.39",
    "WWW::Mechanize"                => "1.52",
    "pQuery"                        => "0.07",
    "Encode"                        => "2.31";

build_requires "Test::More" => "0.86";

repository 'http://github.com/gugod/net-redmine';

tests 't/*.t';
author_tests 'xt';

auto_include;
# auto_license;
WriteAll;

