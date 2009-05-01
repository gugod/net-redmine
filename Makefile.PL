use inc::Module::Install;
name 'Net-Redmine';
all_from 'lib/Net/Redmine.pm';

requires
    'WWW::Mechanize' => 0,
    'Test::Declare' => 0.04;

repository 'http://github.com/gugod/net-redmine'

tests 't/*.t';
author_tests 'xt';

build_requires 'Test::More';

auto_include;
WriteAll;
