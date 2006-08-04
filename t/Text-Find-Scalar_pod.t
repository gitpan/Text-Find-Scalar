# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Text-Find-Scalar.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More;

SKIP:{
    eval "use Test::Pod 1.00";
    skip "Test::Pod 1.00 required",1 if $@;

    my @poddirs = qw(blib);
    all_pod_files_ok(all_pod_files(@poddirs));
}