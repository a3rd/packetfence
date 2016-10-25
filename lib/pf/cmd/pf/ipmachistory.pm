package pf::cmd::pf::ipmachistory;

=head1 NAME

pf::cmd::pf::ipmachistory

=head1 SYNOPSIS

Get the IP/MAC mapping history for a specific IP or MAC with optional date range (in MySQL format)

Syntax: pfcmd ipmachistory <ip|mac> [--start_time=<date> --end_time=<date>] [--limit=<limit>]

Where:

 - <ip|mac> either the IP or the MAC address for which we want the IP/MAC mapping history (REQUIRED)

 - [--start_time=<date> --end_time=<date>] start_time and end_time (in MySQL format) for optional date range (OPTIONAL)

 - [--limit=<limit>] limit the number of returned results. If not specified, all results will be returned (OPTIONAL)

Examples:

  pfcmd ipmachistory 192.168.1.100

  pfcmd ipmachistory de:ad:be:ef:00:42

  pfcmd ipmachistory 192.168.1.100 --start_time="2006-10-12 15:00:00" --end_time="2006-10-18 12:00:00"

  pfcmd ipmachistory 192.168.1.100 --limit=42

=head1 DESCRIPTION

Get the IP/MAC mapping history for a specific IP or MAC with optional date range (in MySQL format)

=cut

use strict;
use warnings;

use Date::Parse;
use Getopt::Long;

use base qw(pf::cmd::display);

sub parseArgs {
    my ( $self ) = @_;

    my ( $key ) = $self->args;
    my ( $start_time, $end_time, $limit );

    GetOptions (
        'start_time:s'  => \$start_time,
        'end_time:s'    => \$end_time,
        'limit:i'       => \$limit,
    );

    if ( $key ) {
        require pf::iplog;
        import pf::iplog;
        my ( $function, %params );
        $function = \&iplog_history;
        $params{'start_time'} = str2time( $start_time) if defined $start_time;
        $params{'end_time'} = str2time( $end_time) if defined $end_time;
        $self->{function} = $function;
        $self->{key} = $key;
        $self->{params} = \%params;
        return 1;
    }

    return 0;
}

=head1 AUTHOR

Inverse inc. <info@inverse.ca>

Minor parts of this file may have been contributed. See CREDITS.

=head1 COPYRIGHT

Copyright (C) 2005-2016 Inverse inc.

=head1 LICENSE

This program is free software; you can redistribute it and::or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301,
USA.

=cut

1;

