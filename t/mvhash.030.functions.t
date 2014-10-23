use lib qw(t);
use Carp;
use Hash::AutoHash::MultiValued;
use Test::More;
use Test::Deep;
use mvhashUtil;

#################################################################################
# test exported functions
#################################################################################
# test object class for sanity sake
my $mvhash=new Hash::AutoHash::MultiValued;
is(ref $mvhash,'Hash::AutoHash::MultiValued',
   "class is Hash::AutoHash::MultiValued - sanity check");

my @imports=@Hash::AutoHash::MultiValued::EXPORT_OK;
import Hash::AutoHash::MultiValued @imports;
pass("import all functions");

my $mvhash=new Hash::AutoHash::MultiValued (key1=>'value11',key2=>'value21'); 
my($actual)=autohash_get($mvhash,qw(key1));
cmp_deeply($actual,['value11'],"autohash_get 1 key");
my @actual=autohash_get($mvhash,qw(key1 key2));
cmp_deeply(\@actual,[[qw(value11)],[qw(value21)]],"autohash_get 2 keys");
my @actual=autohash_get($mvhash,qw(key1 key3));
cmp_deeply(\@actual,[[qw(value11)],undef],"autohash_get 2 keys, 1 non-existant");

autohash_set($mvhash,key2=>'value22');
cmp_mvhash('autohash_set existing key, single value',$mvhash,
	   {key1=>[qw(value11)],key2=>[qw(value21 value22)]});
autohash_set($mvhash,key1=>'value12',key1=>'value13');
cmp_mvhash('autohash_set existing key, multiple values (repeated key form)',$mvhash,
	   {key1=>[qw(value11 value12 value13)],key2=>[qw(value21 value22)]});
autohash_set($mvhash,key2=>[qw(value23 value24)]);
cmp_mvhash('autohash_set existing key, multiple values (ARRAY form)',$mvhash,
	   {key1=>[qw(value11 value12 value13)],key2=>[qw(value21 value22 value23 value24)]});
autohash_set($mvhash,key3=>[qw(value31)]);
cmp_mvhash('autohash_set new key',$mvhash,
	   {key1=>[qw(value11 value12 value13)],key2=>[qw(value21 value22 value23 value24)],
	    key3=>[qw(value31)]});

autohash_set($mvhash,[qw(key3 key4)],[[qw(value32)],[qw(value41 value42)]]);
cmp_mvhash('autohash_set (separate ARRAYs form)',$mvhash,
	   {key1=>[qw(value11 value12 value13)],key2=>[qw(value21 value22 value23 value24)],
	    key3=>[qw(value31 value32)],
	    key4=>[qw(value41 value42)]});

autohash_clear($mvhash);
cmp_mvhash('autohash_clear',$mvhash,{});

my $mvhash=new Hash::AutoHash::MultiValued (key1=>'value11',key2=>'value21');
autohash_delete($mvhash,qw(key2));
cmp_mvhash('autohash_delete 1 key',$mvhash,{key1=>[qw(value11)]});
my $mvhash=new Hash::AutoHash::MultiValued (key0=>'value01',key1=>'value11',key2=>'value21');
autohash_delete($mvhash,qw(key0 key2));
cmp_mvhash('autohash_delete 2 keys',$mvhash,{key1=>[qw(value11)]});
my $mvhash=new Hash::AutoHash::MultiValued (key1=>'value11',key2=>'value21');
autohash_delete($mvhash,qw(key2));
cmp_mvhash('autohash_delete 2 keys, 1 non-existant',$mvhash,{key1=>[qw(value11)]});

my $actual1=autohash_exists($mvhash,'key1');
my $actual2=autohash_exists($mvhash,'key2');
ok($actual1,"autohash_exists: true");
ok(!$actual2,"autohash_exists: false");

my $mvhash=new Hash::AutoHash::MultiValued (key1=>'value11',key2=>'value21');
my %actual;
while (my($key,$value)=autohash_each($mvhash)) {
  $actual{$key}=$value;
}
cmp_deeply(\%actual,{key1=>[qw(value11)],key2=>[qw(value21)]},"autohash_each list context");
my @actual;
while (my $key=autohash_each($mvhash)) {
  push(@actual,$key);
}
cmp_set(\@actual,[qw(key1 key2)],"autohash_each scalar context");

my $mvhash=new Hash::AutoHash::MultiValued (key1=>'value11',key2=>'value21');
my @actual=autohash_keys($mvhash);
cmp_set(\@actual,[qw(key1 key2)],"autohash_keys");

my @actual=autohash_values($mvhash);
cmp_set(\@actual,[[qw(value11)],[qw(value21)]],"autohash_values");

my $actual=autohash_count($mvhash);
is($actual,2,"autohash_count");

my $actual=autohash_empty($mvhash);
ok(!$actual,"autohash_empty: false");
my $actual=autohash_notempty($mvhash);
ok($actual,"autohash_notempty: true");

autohash_clear($mvhash);
my $actual=autohash_empty($mvhash);
ok($actual,"autohash_empty: true");
my $actual=autohash_notempty($mvhash);
ok(!$actual,"autohash_notempty: false");

# cannot test autohash_alias or autohash_tied here.
# must be imported at compile-time for prototype to work

done_testing();
