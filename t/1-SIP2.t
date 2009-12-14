#!/usr/bin/perl

use Test::More tests => 1;

use lib 'lib';

BEGIN {
	use_ok( 'SIP2' );
}

SIP2::dump_message '<<<<' => '09foobar';

