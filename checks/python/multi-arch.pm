# python::multi-arch -- lintian check script -*- perl -*-
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

package Lintian::python::multi_arch;

use strict;
use warnings;

use v5.10; # for the //= operator

use Lintian::Data;
use Lintian::Relation qw(:constants);
use Lintian::Tags qw(tag);

use Lintian::Contrib::Python qw(@dist_packages_re);

my $dist_packages_re = qr{
  $dist_packages_re[2]
| $dist_packages_re[3]
}x;

sub run {
    my ($package, $type, $info) = @_;
    my $ma = $info->field('multi-arch') // 'none';
    my $has_modules = 0;
    for my $file ($info->sorted_index) {
        next unless $info->index($file)->type eq '-';
        if ($file =~ m,$dist_packages_re/.*[.](py|so)$,o) {
            $has_modules = 1;
            last;
        }
    }
    if ($has_modules and ($ma eq 'foreign')) {
        tag 'python-module-in-multi-arch-foreign-package';
    }
    my $data = Lintian::Data->new("python-multi-arch-allowed", ' ');
    my $depends = $info->relation('depends');
    $depends->visit(
        sub {
            my $raw_relation = $_;
            for my $pkg ($data->all) {
                if ($raw_relation =~ m/^\Q$pkg\E:any(\s+[(]>[>=]\s+\S+[)])?$/) {
                    my $relation = Lintian::Relation->new($raw_relation);
                    my $version = $data->value($pkg);
                    my $required_relation = "$pkg:any (>= $version~)";
                    next if $relation->implies($required_relation);
                    tag 'insufficient-any-dependency', $raw_relation, '=>', $required_relation;
                }
            }
        }, VISIT_PRED_FULL
    );
}

1;

# Local Variables:
# indent-tabs-mode: nil
# cperl-indent-level: 4
# End:
# vim: syntax=perl sw=4 sts=4 sr et
