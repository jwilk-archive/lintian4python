# -*- perl -*-
# Lintian::Python

# Copyright © 2012 Jakub Wilk
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
# Web at http://www.gnu.org/copyleft/gpl.html, or write to the Free
# Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston,
# MA 02110-1301, USA.

package Lintian::Python;

use strict;
use warnings;

use base 'Exporter';

use Getopt::Long qw();

our (@EXPORT_OK);
BEGIN {
    @EXPORT_OK = qw(
        parse_update_python_modules
        parse_pycompile
        classify_python_modules
    );
}

sub parse_update_python_modules {
    my ($args) = @_;
    my $error = 0;
    my $ignore = undef;
    local $SIG{__WARN__} = sub { };
    (my $rc, $args) = Getopt::Long::GetOptionsFromString(
        $args,
        'h|help' => \$error,
        'v|verbose' => \$ignore,
        'b|bytecompile' => \$ignore,
        'i|install' => \$ignore,
        'c|clean' => \$error,
        'p|post-install' => \$ignore,
        'a|rebuild-all' => \$ignore,
        'f|force-rebuild-all' => \$ignore,
    );
    return if not $rc;
    return if $error;
    return @{$args};
}

sub parse_pycompile {
    my ($args) = @_;
    my $error = 0;
    my $ignore = undef;
    my $package = undef;
    my $versions = undef;
    local $SIG{__WARN__} = sub { };
    (my $rc, $args) = Getopt::Long::GetOptionsFromString(
        $args,
        'version' => \$error,
        'h|help' => \$error,
        'f|force' => \$ignore,
        'O' => \$error,
        'q|quite' => \$ignore,
        'v|verbose' => \$ignore,
        'p|package=s' => \$package,
        'V=s' => \$versions,
        'X|exclude=s' => \$ignore,
    );
    return if not $rc;
    return if $error;
    return ($package, $versions, @{$args});
}

sub classify_python_modules {
    my ($package, $info) = @_;
    my $postinst = $info->control('postinst');
    my @python3paths = qw(usr/lib/python3);
    my $is_python3_package = 0;
    if ($package =~ m/^python3(?:\.\d+)(?:-.*)?$/) {
        $is_python3_package = 1;
    } else {
        my $depends = $info->relation('strong');
        if ($depends->implies('python3') and not $depends->implies('python')) {
            $is_python3_package = 1;
        }
    }
    unless (-l $postinst or not -f $postinst) {
        open(my $fp, '<', $postinst) or fail("cannot open postinst: $!");
        while (<$fp>) {
            s/^\s+//;
            next unless m/^py3compile\s+(.*)/;
            (undef, undef, my @paths) = parse_pycompile($1);
            for my $path (@paths) {
                $path =~ s,^/+|/+$,,g;
                push @python3paths, $path;
            }
        }
        close($fp);
    }
    my $python2regex = qr(
    ^ (?:
      usr/lib/python2\.\d+
    | usr/share/pyshared
    | usr/share/python-support
    ) / .* [^/][.]py$ )x;
    my $python3regex = sprintf('^(?:%s)/.*[^/][.]py$', join('|', map { quotemeta } @python3paths));
    my @python2files = ();
    my @python3files = ();
    for my $file (@{$info->sorted_index}) {
        my $version = 0;
        next unless $info->index->{$file}->{type} eq '-';
        if ($file =~ $python2regex) {
            $version = 2;
        } elsif ($file =~ $python3regex) {
            $version = 3;
        } elsif (exists $info->scripts->{$file}) {
            next if $file =~ /\.py_tmpl$/;
            my $interpreter = $info->scripts->{$file}->{interpreter};
            if ($interpreter =~ m,^(?:^|.*/)(python(?:\d\S*)?)(?:\s+.*)?$,) {
                $interpreter = $1;
                if ($interpreter =~ /^python3/) {
                    $version = 3;
                } else {
                    $version = 2;
                }
            }
        }
        if ($version == 0 and $file =~ m,[^/][.]py$,) {
            $version = 2 + $is_python3_package;
        }
        if ($version == 2) {
            push @python2files, $file;
        } elsif ($version == 3) {
            push @python3files, $file;
        }
    }
    return (\@python2files, \@python3files);
}

1;

# Local Variables:
# indent-tabs-mode: nil
# cperl-indent-level: 4
# End:
# vim: syntax=perl sw=4 sts=4 sr et
