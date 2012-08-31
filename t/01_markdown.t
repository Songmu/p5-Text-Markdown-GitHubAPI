use strict;
use warnings;
use utf8;

use Test::More;
use Text::Markdown::GitHubAPI qw/markdown/;


like markdown('test'), qr/test/;
like markdown('あいうえお'), qr/あいうえお/;

done_testing;

