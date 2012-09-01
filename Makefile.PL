use inc::Module::Install;
name 'Text-Markdown-GitHubAPI';
all_from 'lib/Text/Markdown/GitHubAPI.pm';

requires 'parent';
requires 'Furl';
requires 'JSON';
requires 'Class::Load';
requires 'Cache::LRU';
requires 'Class::Accessor::Lite';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
auto_set_repository;
auto_include;
WriteAll;
