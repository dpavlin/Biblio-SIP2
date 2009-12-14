#!/usr/bin/perl

use warnings;
use strict;

use IO::Socket::INET;
use autodie;

our $user     = 'sip2-user';
our $password = 'sip2-paasswd';
our $patron   = 200000000042;
our $barcode  = 1301132799;
our $loc      = 'FFZG';

require 'config.pl' if -e 'config.pl';

use SIP2;

our $sock = IO::Socket::INET->new( '10.60.0.251:6001' );


sub sip2 {
	my ( $send, $patt ) = @_;
	SIP2::dump_message '>>>>', $send;
	print $sock "$send\r\n";
	$sock->flush;

#	local $/ = "\r";

	my $in = <$sock>;
	SIP2::dump_message '<<<<', $in;
	die "expected $patt" unless $in =~ $patt;
}

# login
sip2 "9300CN$user|CO$password|" => qr/^941/;

# SC Status
sip2 "9900302.00" => qr/^98/;

# Patron Information
sip2 "6300020091214    085452          AO$loc|AA$patron|AC$password|" => qr/^64/;

# Checkout
sip2 "11YN20091214    124436                  AO$loc|AA$patron|AB$barcode|AC$password|BON|BIN|" => qw/12/;

# Checkin
sip2 "09N20091214    08142820091214    081428AP|AO$loc|AB$barcode|AC|BIN|" => qr/^10/;

