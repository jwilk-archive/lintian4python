# python::extensions -- lintian check script -*- perl -*-
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

package Lintian::python::extensions;

use strict;
use warnings;

use v5.10; # for the // operator

use Lintian::Tags qw(tag);
use Lintian::Util qw(slurp_entire_file);

my $py_extension = qr{
^ (?:
  usr/lib/pyshared/python(2\.\d+)/.+
| usr/lib/python(2\.\d+)/(?:site|dist)-packages/.+
| usr/lib/python-support/(?:[^/]+)/python(2\.\d+)/.+
| usr/lib/python3/dist-packages/.+\.cpython-(\d+)d?mu?
) \.so $
}x;

my $dbg_extension_re = qr{
(?:
  _d
| \.cpython-\d+dmu?
) \. so $
}x;

my $tagless_py3_extension = qr,usr/lib/python3/dist-packages/(?:.+/)?\w+\.so$,;

sub check_static_extension {
    my ($info, $file) = @_;
    $file =~ s,\.so$,\.a,;
    if (defined $info->index($file)) {
        tag 'static-extension', $file;
    }
}

sub check_so_symlink {
    my ($info, $file) = @_;
    return unless $info->index($file)->type eq 'l';
    my $basename = $file;
    $basename =~ s,.*/,,;
    my $link = $info->index($file)->link;
    if ($link =~ m,^\Q$basename\E\.,) {
        tag 'extension-is-symlink', $file, '->', $link;
    }
}

sub run {

my ($pkg, $type, $info, $proc) = @_;

if ($pkg =~ /-dbg$/) {
    # Don't bother checking *-dbg packages.
    return;
}

my $srcpkg = $proc->pkg_src() // '';
my $objdump = $info->objdump_info;
my $uses_old_pyrex_import_type = 0;
my $seen_wrong_version = 0;
my $has_extensions = 0;
my @linked_with_libpython = ();
for my $file ($info->sorted_index) {
    if (my @pyversion = ($file =~ $py_extension)) {
        $has_extensions = 1;
        check_so_symlink($info, $file);
        next unless $info->index($file)->type eq '-';
        my $string = slurp_entire_file($info->strings($file));
        if ($string =~ m,does not appear to be the correct type object,) {
            tag 'extension-uses-old-pyrex-import-type', $file;
        }
        my ($pyversion) = grep { defined $_ } @pyversion;
        $pyversion =~ s,^(\d)(\d+)$,$1.$2,;
        for my $needed (@{$objdump->{$file}->{NEEDED}}) {
            if ($needed =~ m,^libpython(\d\.\d+)(?:mu?)?\.so,) {
                my $libpython = $1;
                if ($libpython ne $pyversion) {
                    $seen_wrong_version = 1;
                    tag 'extension-compiled-for-wrong-version', $libpython, $file;
                } else {
                    push @linked_with_libpython, $file;
                }
            }
        }
        my @sonames = @{$objdump->{$file}->{SONAME}};
        if (@sonames) {
            tag 'extension-with-soname', $file, "(@sonames)";
        }
        if ($file =~ $dbg_extension_re) {
            tag 'dbg-extension-in-non-dbg-package', $file;
        }
        check_static_extension($info, $file);
    } elsif ($file =~ $tagless_py3_extension) {
        $has_extensions = 1;
        check_so_symlink($info, $file);
        next unless $info->index($file)->type eq '-';
        tag 'python3-extension-without-abi-tag', $file;
        check_static_extension($info, $file);
    }
}
unless ($seen_wrong_version) {
    for my $file (@linked_with_libpython) {
        tag 'extension-linked-with-libpython', $file;
    }
}

}

1;

# Local Variables:
# indent-tabs-mode: nil
# cperl-indent-level: 4
# End:
# vim: syntax=perl sw=4 sts=4 sr et
