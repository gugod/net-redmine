use inc::Module::Install;
name 'Net-Redmine';
all_from 'lib/Net/Redmine.pm';

requires
    'WWW::Mechanize' => 0,
    'pQuery' => 0,
    'HTML::WikiConverter' => 0,
    'HTML::WikiConverter::Markdown' => 0;

repository 'http://github.com/gugod/net-redmine';

tests 't/*.t';
author_tests 'xt';

build_requires 'Test::More';

auto_include;
# auto_license;
WriteAll;

