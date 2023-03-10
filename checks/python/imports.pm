# python::imports -- lintian check script -*- perl -*-
#
# Copyright © 2011, 2012, 2013 Jakub Wilk
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

package Lintian::python::imports;

use strict;
use warnings;

use v5.10; # for the //= operator

use Lintian::Tags qw(tag);

sub run {

my ($pkg, $type, $info) = @_;
my %needed = ();

for my $file (sort keys %{$info->scripts}) {
    next unless $info->index($file)->type eq '-';
    my $interpreter = $info->scripts->{$file}->{interpreter};
    my ($base) = $interpreter =~ m,([^/]*)$,;
    if ($base =~ m/^python(?:([23])(?:\.[0-9]+)?)?$/) {
        my $py3k = (defined($1) and $1 eq '3');
        my $path = $info->unpacked($file);
        open(my $fh, '<', $path) or fail("could not open script $path");
        while (<$fh>) {
            if (m,^from\s+pkg_resources\s+import(\s+|$),) {
                my $demand = 'pkg_resources;python-pkg-resources;python-setuptools';
                if ($py3k) {
                    $demand =~ s/python-/python3-/g;
                }
                $needed{$demand} //= {};
                $needed{$demand}->{$file} = 1;
           }
        }
        close($fh);
    }
}

while (my ($depends, $scripts) = each %needed) {
    (my $module, $depends, my $extra_depends) = split(';', $depends, 3);
    next if $info->relation('strong')->implies($depends);
    next if defined $extra_depends and $info->relation('strong')->implies($extra_depends);
    tag 'missing-dependency-for-import',
        $module,
        '(' . join(' ', keys %$scripts) . ')',
        '=>',  $depends;
}

}

1;

# Local Variables:
# indent-tabs-mode: nil
# cperl-indent-level: 4
# End:
# vim: syntax=perl sw=4 sts=4 sr et
