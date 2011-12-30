#!/usr/bin/perl

use warnings;
use strict;

use lib 'lib';
use SIP2::ACS;

my @proxy = ( '10.60.0.11:6001' => '10.60.0.11:6002' );
@proxy = @ARGV if @ARGV;

SIP2::ACS::proxy( @proxy );

