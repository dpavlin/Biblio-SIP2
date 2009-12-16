#!/usr/bin/perl

use Test::More tests => 2;

use lib 'lib';

BEGIN {
	use_ok( 'SIP2' );
	use_ok( 'SIP2::SC' );
}
