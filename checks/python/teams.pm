# python::teams -- lintian check script -*- perl -*-
#
# Copyright © 2011, 2013 Jakub Wilk
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, you can find it on the World Wide
# Web at https://www.gnu.org/copyleft/gpl.html, or write to the Free
# Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston,
# MA 02110-1301, USA.

package Lintian::python::teams;

use strict;
use warnings;

use v5.10; # for the // operator

use Lintian::Tags qw(tag);

my %TEAMS = (
    dpmt => {
        name => 'Debian Python Modules Team',
        email => 'python-modules-team@lists.alioth.debian.org',
        vcs_browser => [
            'http://anonscm.debian.org/viewvc/python-modules/packages/%s/trunk/',
            '^http://(?:anonscm|svn)[.]debian[.]org/view(?:svn|vc)/python-modules/packages/%s/trunk/?$',
        ],
        vcs_svn => [
            'svn://anonscm.debian.org/python-modules/packages/%s/trunk/',
            '^svn://(?:svn|anonscm)[.]debian[.]org/(?:svn/)?python-modules/packages/%s(?:/trunk)?/?$'
        ],
    },
    papt => {
        name => 'Python Applications Packaging Team',
        email => 'python-apps-team@lists.alioth.debian.org',
        vcs_browser => [
            'http://anonscm.debian.org/viewvc/python-apps/packages/%s/trunk/',
            '^http://(?:anonscm|svn)[.]debian[.]org/view(?:svn|vc)/python-apps/packages/%s/trunk/?$',
        ],
        vcs_svn => [
            'svn://anonscm.debian.org/python-apps/packages/%s/trunk/',
            '^svn://(?:svn|anonscm)[.]debian[.]org/(?:svn/)?python-apps/packages/%s(?:/trunk)?/?$'
        ]
    }
);

sub run {

my ($pkg, $type, $info) = @_;
my %teams = ();
my @maintainers;
for (qw(maintainer uploaders)) {
    push @maintainers, split(m/\>\K\s*,\s*/, $info->field($_) // '');
}
for (@maintainers) {
    my ($name, $email) = /^\s*(\S|\S.*\S)\s*<(\S+)>\s*$/ or next;
    while (my ($team, $info) = each %TEAMS) {
        if ($email eq $info->{email}) {
            $teams{$team} = 1;
            if ($name ne $info->{name}) {
                tag 'incorrect-team-name', $name, '->', $info->{name};
            }
        }
    }
}
if ($type eq 'source' and (keys %teams) > 0) {
    foreach my $team (keys %teams) {
        $team = $TEAMS{$team};
        while ((my $key, my $value) = each %{$team}) {
            next unless $key =~ /vcs_(.*)/;
            my $vcs_type = $1;
            my ($team_vcs_value, $team_vcs_regex) = @{$value};
            $team_vcs_value = sprintf($team_vcs_value, $pkg);
            $team_vcs_regex = sprintf($team_vcs_regex, quotemeta($pkg));
            my $vcs_value = $info->field("vcs-$vcs_type");
            if (not defined $vcs_value) {
                tag 'missing-vcs-field', "vcs-$vcs_type", $team_vcs_value;
            } else {
                if (not $vcs_value =~ qr/$team_vcs_regex/) {
                    tag 'incorrect-vcs-field', "vcs-$vcs_type", $vcs_value, '->', $team_vcs_value;
                }
            }
        }
    }
}

}

1;

# Local Variables:
# indent-tabs-mode: nil
# cperl-indent-level: 4
# End:
# vim: syntax=perl sw=4 sts=4 sr et
