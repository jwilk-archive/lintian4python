# python::package-name -- lintian check script -*- perl -*-
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

package Lintian::python::package_name;

use strict;
use warnings;

use v5.10; # for the // operator

use Lintian::Tags qw(tag);
use Lintian::Util qw(fail);

use Lintian::Contrib::Python qw(@dist_packages_re);

my $_extension_suffix = qr{
(?: [.]cpython-(?:\d+)mu?
  | (?<!_d)
)
\. so
}x;

my @path_additions = map {
    my $data = Lintian::Data->new("python$_-sys.path-additions", ' => ');
    my @result = $data->all();
    @result = grep { ! m,^/, } @result;
    my $result = join('|', map(quotemeta, @result));
    if ($result) {
        $result = qr/$result/;
    } else {
        $result = qr/x\A/; # never matches anything
    }
    $result;
} (2..3);
unshift(@path_additions, undef, undef);

my $_module_name = qr{
(?:
  $dist_packages_re[2]/(?: $path_additions[2] / )?
| $dist_packages_re[3]/(?: $path_additions[3] / )?
)
( (?: [^/]*/ )* )
(?: (\w+)module$_extension_suffix
  | (\w+)$_extension_suffix
  | (\w+)\.py
) $
}x;

sub reduce {
    my ($key, $node) = @_;
    if (ref $node) {
        if (exists $node->{'__init__'} or exists $node->{'__main__'}) {
            return $key;
        }
        if (scalar keys %{$node} == 1) {
            my ($subkey) = keys %{$node};
            my ($subvalue) = $node->{$subkey};
            return sprintf('%s.%s', $key, reduce($subkey, $subvalue));
        } else {
            return $key;
        }
    } else {
        return $key;
    }
}

sub run {
    my ($package, $type, $info) = @_;
    $package =~ m/^(python3?)-/ or return;
    my $prefix = $1;
    if ($package eq 'python-support') {
        return;
    }
    if (($info->field('section') // '') eq 'debug') {
        return;
    }
    my %data = ();
    for my $file ($info->sorted_index) {
        next unless $info->index($file)->type eq '-';
        if ($file =~ $_module_name) {
            my $path = $1;
            my $module = $2 // $3 // $4;
            my @path = split '/', $path;
            my $current = \%data;
            for (@path) {
                $current->{$_} //= {};
                $current = $current->{$_};
            }
            $current->{$module} = 1
                if $module =~ m/^__.*__$/
                or $module !~ m/^_/;
        }
    }
    if (scalar keys %data > 0) {
        my $ok = 0;
        my @proposed_names = map {
            $_ = reduce($_, $data{$_});
            y/_/-/;
            $_ = "$prefix-\L$_";
            if ($package eq $_) {
                $ok = 1;
            }
            $_;
        } keys %data;
        unless ($ok) {
            local $" = ' | ';
            tag 'incorrect-package-name', "@proposed_names";
        }
    }
}

1;

# Local Variables:
# indent-tabs-mode: nil
# cperl-indent-level: 4
# End:
# vim: syntax=perl sw=4 sts=4 sr et
