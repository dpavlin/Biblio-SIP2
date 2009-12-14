#!/usr/bin/perl

use warnings;
use strict;

use IO::Socket::INET;
use autodie;
use Data::Dump qw(dump);

our $user     = 'sip2-user';
our $password = 'sip2-paasswd';

require 'config.pl' if -e 'config.pl';

our $sock = IO::Socket::INET->new( '10.60.0.251:6001' );

sub sip2 {
	my ( $send, $patt ) = @_;
	warn ">>>> ", dump($send), "\n";
	print $sock "$send\r\n";
	$sock->flush;

#	local $/ = "\r";

	my $in = <$sock>;
	warn "<<<< ", dump($in), "\n";
	die "expected $patt" unless $in =~ $patt;
}

# login
sip2 "9300CN$user|CO$password|" => qr/^941/;

# SC Status
sip2 "9900302.00" => qr/^98/;

# Checkin
sip2 "09N20091214    08142820091214    081428AP|AOFFZG|AB1301036581|AC|BIN|" => qr/^10/;

# Patron Information
sip2 "6300020091214    085452          AOFFZG|AA200903260093|AC$password|" => qr/^54/;
