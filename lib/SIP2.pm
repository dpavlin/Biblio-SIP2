package SIP2;

use Data::Dump qw();

our $sock;

sub connect {
	$sock = IO::Socket::INET->new( @_ ) || die "can't connect to ", dump(@_), ": $!";
}


my $message_codes;
foreach ( <DATA> ) {
	my ($code,$description) = split(/\t/,$_,2);
	$message_codes->{$code} = $description;
}
warn "# message_codes ", Data::Dump::dump $message_codes;

sub dump_message {
	my ( $prefix, $message ) = @_;
	my $code = substr($message,0,2);
	warn $prefix, " ", $message_codes->{$code}, Data::Dump::dump($message), "\n";
}


sub send {
	my ( $send ) = @_;
	SIP2::dump_message '>>>>', $send;
	print $sock "$send\r\n";
	$sock->flush;

#	local $/ = "\r";

	my $expect = substr($send,0,2) | 0x01;

	my $in = <$sock>;
	SIP2::dump_message '<<<<', $in;
	die "expected $expect" unless substr($in,0,2) != $expect;
}


1;

__DATA__
09	Checkin
10	Checkin Response
11	Checkout
12	Checkout Response
35	End Patron Session
36	End Session Response
63	Patron Information
64	Patron Information Response
93	Login
94	Login Response
98	ACS Status
99	SC Status
