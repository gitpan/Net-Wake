package Net::Wake;

use strict;
use IO::Socket;

use vars qw($VERSION);
$VERSION = '0.01';

=head1 NAME

Net::Wake - A package to send packets to power on computers.

=head1 SYNOPSIS

To send a wake-on-lan packet via UDP:

Net::Wake::by_udp('192.168.1.2', '00:00:87:A0:8A:D2');

=head1 DESCRIPTION

This package sends wake-on-lan packets to turn on machines that
are wake-on-lan capable.

For now there is only one function in this package:

Net::Wake::by_udp(host, mac_address, [port]);

One can omit the colons in the mac_address, but not leading zeros.

=head1 SEE ALSO

 http://www.pc.ibm.com/us/infobrf/iblan.html
 http://www.nec-computers.com/about/tech/wp-wakeon.html

=head1 COPYRIGHT

Copyright 1999 Clinton Wong

This program is free software; you can redistribute it
and/or modify it under the same terms as Perl itself.

=cut

sub by_udp {
  my ($host, $mac_addr, $port) = @_;

  # use the discard service if $port not passed in
  if (! defined $port || $port !~ /^\d+$/ ) { $port = 9 }

  my $sock = new IO::Socket::INET(	Proto=>'udp') || return undef;

  my $ip_addr = inet_aton($host);
  my $sock_addr = sockaddr_in($port, $ip_addr);
  $mac_addr =~ s/://g;
  my $packet = pack('C6H*', 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, $mac_addr x 16);
  send($sock, $packet, 0, $sock_addr);
  close ($sock);
}

1;

