# python::pth -- lintian check script -*- perl -*-
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

package Lintian::python::pth;

use v5.10; # for the %+ hash

use strict;
use warnings;

use Lintian::Tags qw(tag);
use Lintian::Util qw(fail);

use Lintian::Contrib::Python qw(@dist_packages_re);

my $dist_packages_re = qr{
  ( $dist_packages_re[2] )
| ( $dist_packages_re[3] )
}x;

my @path_additions = map {
    Lintian::Data->new("python$_-sys.path-additions", ' => ');
} (2..3);
unshift(@path_additions, undef, undef);

my $i;
my @path_additions_re = map {
    my $result = undef;
    if (defined $_) {
        my @result = $_->all();
        @result = map {
            my $result = "(?P<addition>\Q$_\E)";
            unless (m,^/,) {
                $result = "$dist_packages_re[$i]/$result";
            }
            $result;
        } @result;
        if (@result) {
            $result = join('|', @result);
            $result = qr/$result/;
        } else {
            $result = qr/x\A/; # never matches anything
        }
    }
    $i++;
    $result;
} @path_additions;

sub run {

    my ($package, $type, $info) = @_;

    my $version = $info->field('version');
    my %egg_versions = ();
    my $depends = $info->relation('strong');
    my $self_relation = Lintian::Relation->new("$package (= $version)");
    my %required_depends = ();
    for my $file ($info->sorted_index) {
        next unless $info->index($file)->type eq '-';
        if ($file =~ m,^$dist_packages_re/([^/]+)[.]pth$,) {
            open(my $fh, '<', $info->unpacked($file)) or fail("cannot open .pth file: $!");
            while (<$fh>) {
                if (m,^import[ \t],) {
                    # executable import statements
                    # TODO: allow setuptools magic, but discourage anything else
                } else {
                    chomp;
                    tag 'pth-file-modifies-sys.path', $file, $_;
                }
            }
            close($fh);
        } else {
            for my $version (2, 3) {
                if ($file =~ m,^$path_additions_re[$version],) {
                    my $addition = $+{'addition'};
                    my $rd = $path_additions[$version]->value($addition);
                    $required_depends{$rd} = "$addition => $rd";
                    last;
                }
            }
        }
    }
    foreach my $rd (sort keys %required_depends) {
        next if $self_relation->implies($rd);
        next if $depends->implies($rd);
        tag 'misssing-dependency-for-sys.path-addition', $required_depends{$rd};
    }
}

1;

# Local Variables:
# indent-tabs-mode: nil
# cperl-indent-level: 4
# End:
# vim: syntax=perl sw=4 sts=4 sr et
