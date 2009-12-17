package SIP2::ACS;

=head1 NAME

SIP2::ACS - Automated Circulation System

=head1 DESCRIPTION

Basically just a simple proxy to real ACS server

=cut

use warnings;
use strict;

use IO::Socket::INET;
use IO::Select;

use Data::Dump qw(dump);

use lib 'lib';
use SIP2::SC;

my $listen = '127.0.0.1:6001';
my $server = '10.60.0.251:6001';

warn "listen on $listen for SIP2/RAW\n";

my $lsn = IO::Socket::INET->new(Listen => 1, LocalAddr => $listen, Reuse => 1) or die $!;
my $sel = IO::Select->new($lsn);

our $sc;

local $/ = "\r";

while (1) {
	for my $sock ($sel->can_read(1)) {

		if ($sock == $lsn) {
			my $new = $lsn->accept;
			my $ip = $sock->peerhost;
			warn "connection from $ip\n";
			$sel->add($new);
		} else {
			warn dump($sock);
			my $line = <$sock>;
			my $ip = $sock->peerhost;
			warn "<< $ip ", dump($line);
			if ( ! $sc->{$sock} ) {
				warn "no $sock in ",dump( $sc );
				$sc->{$sock} = SIP2::SC->new( $server );
			}
 			$line .= "\n"; # lf to fix Koha ACS
			print $sock $sc->{$sock}->message( $line )
		}
	}
}

1;

