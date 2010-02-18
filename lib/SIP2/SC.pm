package SIP2::SC;

=head1 NAME

SIP2::SC - SelfCheck system or library automation device dealing with patrons or library materials

=cut


use warnings;
use strict;

use IO::Socket::INET;
use Data::Dump qw(dump);
use autodie;

use lib 'lib';
use base qw(SIP2);

sub new {
	my $class = shift;
	my $self;
	$self->{sock} = IO::Socket::INET->new( @_ ) || die "can't connect to ", dump(@_), ": $!";
	warn "# connected to ", $self->{sock}->peerhost, ":", $self->{sock}->peerport, "\n";
	bless $self, $class;
	$self;
}

sub message {
	my ( $self, $send ) = @_;

	local $/ = "\r";

	my $sock = $self->{sock} || die "no sock?";
	my $ip = $self->{sock}->peerhost;

	$send .= "\r" unless $send =~ m/\r/;

	$self->dump_message( ">>>> $ip ", $send );
	print $sock $send;
	$sock->flush;

	my $expect = substr($send,0,2) | 0x01;

	my $in = <$sock>;

	die "ERROR: no response from $ip\n" unless $in;

	$in =~ s/^\n// && warn "removed LF from beginning";
	$self->dump_message( "<<<< $ip ", $in );
	die "expected $expect" unless substr($in,0,2) != $expect;

	return $in;
}

1;
