#!/usr/bin/perl

use warnings;
use strict;

use IO::Socket::INET;
use autodie;

our $user     = 'sip2-user';
our $password = 'sip2-paasswd';

require 'config.pl' if -e 'config.pl';

our $sock = IO::Socket::INET->new( '10.60.0.251:6001' );

sub sip2 {
	my ( $send, $patt ) = @_;
	warn ">>>> $send";
	print $sock $send;

	my $in = <$sock>;
	warn "<<<< $in";
	die unless $in =~ $patt;
}

sip2 "9300CN$user|CO$password|\n" => qr/^941/;

