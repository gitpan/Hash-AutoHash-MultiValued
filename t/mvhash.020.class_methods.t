use lib qw(t);
use Carp;
use Hash::AutoHash::MultiValued;
use Test::More;
use Test::Deep;
use mvhashUtil;

# test object class for sanity sake
my $mvhash=new Hash::AutoHash::MultiValued;
is(ref $mvhash,'Hash::AutoHash::MultiValued',
   "class is Hash::AutoHash::MultiValued - sanity check");

my $mvhash=new Hash::AutoHash::MultiValued;
ok($mvhash,"Hash::AutoHash::MultiValued new");

my $can=can Hash::AutoHash::MultiValued('can');
ok($can,"can: can");
my $can=can Hash::AutoHash::MultiValued('new');
ok($can,"can: new");
my $can=can Hash::AutoHash::MultiValued('not_defined');
ok(!$can,"can: can\'t");

my $isa=isa Hash::AutoHash::MultiValued(Hash::AutoHash::MultiValued);
ok($isa,"isa: is Hash::AutoHash::MultiValued");
my $isa=isa Hash::AutoHash::MultiValued('Hash::AutoHash');
ok($isa,"isa: is Hash::AutoHash");
my $isa=isa Hash::AutoHash::MultiValued('UNIVERSAL');
ok($isa,"isa: is UNIVERSAL");
my $isa=isa Hash::AutoHash::MultiValued('not_defined');
ok(!$isa,"isa: isn\'t");

my $version=VERSION Hash::AutoHash::MultiValued;
is($version,$Hash::AutoHash::MultiValued::VERSION,"VERSION");

my @imports=@Hash::AutoHash::MultiValued::EXPORT_OK;
import Hash::AutoHash::MultiValued @imports;
pass("import all functions");

done_testing();
