# python::scripts -- lintian check script -*- perl -*-
#
# Copyright © 2012, 2013 Jakub Wilk
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

package Lintian::python::scripts;

use strict;
use warnings;

use Lintian::Tags qw(tag);

sub run {

my %executable;
my ($pkg, $type, $info) = @_;

foreach ($info->sorted_index) {
    next if $_ eq '';
    my $index_info = $info->index($_);
    my $operm = $index_info->operm;
    next unless $index_info->type =~ m,^[-h], and ($operm & 0111);
    $executable{$_} = 1;
}
for my $filename (sort keys %{$info->scripts}) {
    next unless $executable{$filename};
    my $orig_interpreter = my $interpreter = $info->scripts->{$filename}->{interpreter};
    next unless $interpreter =~ m,^(?:^|.*/)(python(?:\d\S*)?)(?:\s+.*)?$,;
    $interpreter =~ s//$1/;
    my $calls_env = $info->scripts->{$filename}->{calls_env};
    if ($calls_env) {
        tag 'usr-bin-env-python-shebang', $filename
            unless $filename =~ m,^usr/share/doc/,;
    }
    if ($interpreter =~ m,^python(\d+\.\d+),) {
        my $version = $1;
        tag 'versioned-python-shebang', $filename, $orig_interpreter
            unless $filename =~ m,\Q$version\E[^/]*$, or
                $pkg =~ m/\bpython\Q$version\E(?:-.+)?$/;
    }
}

}

1;

# Local Variables:
# indent-tabs-mode: nil
# cperl-indent-level: 4
# End:
# vim: syntax=perl sw=4 sts=4 sr et
