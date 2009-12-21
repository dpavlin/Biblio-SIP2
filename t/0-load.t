#!/usr/bin/perl

use Test::More tests => 3;

use lib 'lib';

BEGIN {
	use_ok( 'SIP2' );
	use_ok( 'SIP2::SC' );
	use_ok( 'SIP2::ACS' );
}
