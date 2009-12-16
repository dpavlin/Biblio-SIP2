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

SIP2::connect '10.60.0.251:6001';

# login
SIP2::send "9300CN$user|CO$password|";

# SC Status
SIP2::send "9900302.00";

# Patron Information
SIP2::send "6300020091214    085452          AO$loc|AA$patron|AC$password|";

# Checkout
SIP2::send "11YN20091214    124436                  AO$loc|AA$patron|AB$barcode|AC$password|BON|BIN|";

# Checkin
SIP2::send "09N20091214    08142820091214    081428AP|AO$loc|AB$barcode|AC|BIN|";


# checkout another
SIP2::send "09N20091216    15320820091216    153208AP|AOFFZG|AB200903160190|ACviva2koha|BIN|";

# status
SIP2::send "9900302.00";

