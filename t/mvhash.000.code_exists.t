use lib qw(t);
use strict;
use Test::More;
use Test::Deep;
# make sure all the necesary modules exist
BEGIN {
  use_ok('Hash::AutoHash');
  use_ok('Hash::AutoHash::MultiValued');
}

done_testing();
