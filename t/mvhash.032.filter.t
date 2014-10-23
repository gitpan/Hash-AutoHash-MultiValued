use lib qw(t);
use Carp;
use Hash::AutoHash::MultiValued qw(autohash_tied autohash_set);
use Test::More;
use Test::Deep;
use mvhashUtil;

#################################################################################
# test filter. not tested in 030.functions because it relies on autohash_tied
# which is tested separately
#################################################################################

sub test_filter {
  my($label,$filter,$initial_value,$after_filter,$update,$after_update)=@_;
  $label=label_filter($label,$filter);
  my $mvhash=new Hash::AutoHash::MultiValued %$initial_value;
#  cmp_mvhash("$label initial value",$mvhash,$initial_value);
  autohash_tied($mvhash)->filter($filter);
  cmp_mvhash("$label after filter",$mvhash,$after_filter);
 # update via methods
  while(my($key,$value)=each %$update) {
    $mvhash->$key($value);
  }
  cmp_mvhash("$label after update via methods",$mvhash,$after_update);

  # reset mvhash for next test
  my $mvhash=new Hash::AutoHash::MultiValued %$initial_value;
#  cmp_mvhash("$label restore initial value",$mvhash,$initial_value);
  autohash_tied($mvhash)->filter($filter);
  cmp_mvhash("$label after filter",$mvhash,$after_filter);
 # update via hash operations
  @$mvhash{keys %$update}=values %$update;
  cmp_mvhash("$label after update via hash operations",$mvhash,$after_update);

  # reset mvhash for next test
  my $mvhash=new Hash::AutoHash::MultiValued %$initial_value;
#  cmp_mvhash("$label restore initial value",$mvhash,$initial_value);
  autohash_tied($mvhash)->filter($filter);
  cmp_mvhash("$label after filter",$mvhash,$after_filter);
  # update via set function
  autohash_set($mvhash,%$update);
  cmp_mvhash("$label after update via autohash_set",$mvhash,$after_update);
}
sub label_filter {
  my($label,$filter)=@_;
  return "filter sub: $label" if 'CODE' eq ref $filter;
  return "filter  on: $label" if $filter;
  return "filter off: $label";
}
my $sub=sub {map {uc $_} @_};

test_filter('0 keys','filter',
	    {},
	    {},
	    {key1=>[qw(value11)],key2=>[qw(value21)]},
	    {key1=>[qw(value11)],key2=>[qw(value21)]});
test_filter('0 keys. no dups.',$sub,
	    {},
	    {},
	    {key1=>[qw(value11)],key2=>[qw(value21)]},
	    {key1=>[qw(value11)],key2=>[qw(value21)]});
test_filter('0 keys. no dups.',undef,
	    {},
	    {},
	    {key1=>[qw(value11)],key2=>[qw(value21)]},
	    {key1=>[qw(value11)],key2=>[qw(value21)]});

test_filter('2 keys. 0 values.','filter',
	    {key1=>[],key2=>[]},
	    {key1=>[],key2=>[]},
	    {key1=>[qw(value11)],key2=>[qw(value21)]},
	    {key1=>[qw(value11)],key2=>[qw(value21)]});
test_filter('2 keys. 0 values.',$sub,
	    {key1=>[],key2=>[]},
	    {key1=>[],key2=>[]},
	    {key1=>[qw(value11)],key2=>[qw(value21)]},
	    {key1=>[qw(value11)],key2=>[qw(value21)]});
test_filter('2 keys. 0 values.',undef,
	    {key1=>[],key2=>[]},
	    {key1=>[],key2=>[]},
	    {key1=>[qw(value11)],key2=>[qw(value21)]},
	    {key1=>[qw(value11)],key2=>[qw(value21)]});

test_filter('2 keys. 0 values. dup update','filter',
	    {key1=>[],key2=>[]},
	    {key1=>[],key2=>[]},
	    {key1=>[qw(value11 value11)],key2=>[qw(value21 value21)]},
	    {key1=>[qw(value11 value11)],key2=>[qw(value21 value21)]});
test_filter('2 keys. 0 values. dup update',$sub,
	    {key1=>[],key2=>[]},
	    {key1=>[],key2=>[]},
	    {key1=>[qw(value11 value11)],key2=>[qw(value21 value21)]},
	    {key1=>[qw(value11 value11)],key2=>[qw(value21 value21)]});
test_filter('2 keys. 0 values. dup update',undef,
	    {key1=>[],key2=>[]},
	    {key1=>[],key2=>[]},
	    {key1=>[qw(value11 value11)],key2=>[qw(value21 value21)]},
	    {key1=>[qw(value11 value11)],key2=>[qw(value21 value21)]});

test_filter('2 keys. single values. no dups.','filter',
	    {key1=>[qw(value11)],key2=>[qw(value21)]},
	    {key1=>[qw(value11)],key2=>[qw(value21)]},
	    {key1=>[qw(value12)],key2=>[qw(value22)]},
	    {key1=>[qw(value11 value12)],key2=>[qw(value21 value22)]});
test_filter('2 keys. single values. no dups.',$sub,
	    {key1=>[qw(value11)],key2=>[qw(value21)]},
	    {key1=>[qw(VALUE11)],key2=>[qw(VALUE21)]},
	    {key1=>[qw(value12)],key2=>[qw(value22)]},
	    {key1=>[qw(VALUE11 value12)],key2=>[qw(VALUE21 value22)]});
test_filter('2 keys. single values. no dups.',undef,
	    {key1=>[qw(value11)],key2=>[qw(value21)]},
	    {key1=>[qw(value11)],key2=>[qw(value21)]},
	    {key1=>[qw(value12)],key2=>[qw(value22)]},
	    {key1=>[qw(value11 value12)],key2=>[qw(value21 value22)]});

test_filter('2 keys. multiple values. dup update.','filter',
	    {key1=>[qw(value11 value12)],key2=>[qw(value21 value22)]},
	    {key1=>[qw(value11 value12)],key2=>[qw(value21 value22)]},
	    {key1=>[qw(value12)],key2=>[qw(value22)]},
	    {key1=>[qw(value11 value12 value12)],key2=>[qw(value21 value22 value22)]});
test_filter('2 keys. multiple values. dup update.',$sub,
	    {key1=>[qw(value11 value12)],key2=>[qw(value21 value22)]},
	    {key1=>[qw(VALUE11 VALUE12)],key2=>[qw(VALUE21 VALUE22)]},
	    {key1=>[qw(value12)],key2=>[qw(value22)]},
	    {key1=>[qw(VALUE11 VALUE12 value12)],key2=>[qw(VALUE21 VALUE22 value22)]});
test_filter('2 keys. multiple values. dup update.',undef,
	    {key1=>[qw(value11 value12)],key2=>[qw(value21 value22)]},
	    {key1=>[qw(value11 value12)],key2=>[qw(value21 value22)]},
	    {key1=>[qw(value12)],key2=>[qw(value22)]},
	    {key1=>[qw(value11 value12 value12)],key2=>[qw(value21 value22 value22)]});

test_filter('2 keys. 1 with dups.','filter',
	    {key1=>[qw(value11)],key2=>[qw(value21 value21)]},
	    {key1=>[qw(value11)],key2=>[qw(value21)]},
	    {key1=>[qw(value12 value12)],key2=>[qw(value22)]},
	    {key1=>[qw(value11 value12 value12)],key2=>[qw(value21 value22)]});
test_filter('2 keys. 1 with dups.',$sub,
	    {key1=>[qw(value11)],key2=>[qw(value21 VALUE21)]},
	    {key1=>[qw(VALUE11)],key2=>[qw(VALUE21 VALUE21)]},
	    {key1=>[qw(value12 value12)],key2=>[qw(value22)]},
	    {key1=>[qw(VALUE11 value12 value12)],key2=>[qw(VALUE21 VALUE21 value22)]});
test_filter('2 keys. 1 with dups.',undef,
	    {key1=>[qw(value11)],key2=>[qw(value21 value21)]},
	    {key1=>[qw(value11)],key2=>[qw(value21 value21)]},
	    {key1=>[qw(value12 value12)],key2=>[qw(value22)]},
	    {key1=>[qw(value11 value12 value12)],key2=>[qw(value21 value21 value22)]});

test_filter('2 keys. mixed unique & dups.','filter',
	    {key1=>[qw(value11)],key2=>[qw(value21 value22 value22 value23)]},
	    {key1=>[qw(value11)],key2=>[qw(value21 value22 value23)]},
	    {key1=>[qw(value12 value12)],key2=>[qw(value22 value23 value24)]},
	    {key1=>[qw(value11 value12 value12)],
	     key2=>[qw(value21 value22 value23 value22 value23 value24)]});
test_filter('2 keys. mixed unique & dups.',$sub,
	    {key1=>[qw(value11)],key2=>[qw(value21 value22 VALUE22 value23)]},
	    {key1=>[qw(VALUE11)],key2=>[qw(VALUE21 VALUE22 VALUE22 VALUE23)]},
	    {key1=>[qw(value12 value12)],key2=>[qw(value22 value23 value24)]},
	    {key1=>[qw(VALUE11 value12 value12)],
	     key2=>[qw(VALUE21 VALUE22 VALUE22 VALUE23 value22 value23 value24)]});
test_filter('2 keys. mixed unique & dups.',undef,
	    {key1=>[qw(value11)],key2=>[qw(value21 value22 value22 value23)]},
	    {key1=>[qw(value11)],key2=>[qw(value21 value22 value22 value23)]},
	    {key1=>[qw(value12 value12)],key2=>[qw(value22 value23 value24)]},
	    {key1=>[qw(value11 value12 value12)],
	     key2=>[qw(value21 value22 value22 value23 value22 value23 value24)]});

done_testing();
