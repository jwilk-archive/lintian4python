# python::depends -- lintian check script -*- perl -*-
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

package Lintian::python::depends;

use strict;
use warnings;

use Lintian::Tags qw(tag);
use Lintian::Relation qw(:constants);

sub run {

    my ($pkg, $type, $info) = @_;

    my $relation = $info->relation($type eq 'binary' ? 'all' : 'build-depends-all');
    $relation->visit(
        sub {
            if (m/^(python3?-numpy)\s+\((>>|>=|=)\s+([1-9][^:)]*)\)$/) {
                tag 'missing-epoch-in-dependency', "$1 ($2 $3)";
            }
        }, VISIT_PRED_FULL
    );

    if ($type eq 'source') {
        my @binpkgs = sort $info->binaries;
        for my $binpkg (@binpkgs) {
            my $relation = $info->binary_relation($binpkg, 'all');
            $relation->visit(
                sub {
                    if (m/^(python3?-numpy-a[bp]i\d+)$/) {
                        tag 'hardcoded-dependency-on-numpy-virtual-package', $1;
                    }
                }, VISIT_PRED_FULL
            );
        }
    }

    if ($type eq 'binary') {
        for my $field (qw(conflicts replaces provides)) {
            my $relation = $info->relation($field);
            $relation->visit(
                sub {
                    if (m/^python(1[.][0-9]+|2[.][0-4])-/) {
                        # obsolete-conflicts or
                        # obsolete-replaces or
                        # obsolete-provides
                        tag "obsolete-$field", $_;
                    }
                }, VISIT_PRED_FULL
            );
        }
    }

}

1;

# Local Variables:
# indent-tabs-mode: nil
# cperl-indent-level: 4
# End:
# vim: syntax=perl sw=4 sts=4 sr et
