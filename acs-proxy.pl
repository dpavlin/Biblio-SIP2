#!/usr/bin/perl

use warnings;
use strict;

use lib 'lib';
use SIP2::ACS;

SIP2::ACS::proxy( '127.0.0.1:6001' => '10.60.0.251:6001' );
