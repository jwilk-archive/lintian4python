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

package Lintian::Contrib::Python;

use strict;
use warnings;

use base 'Exporter';

use Getopt::Long qw();

use Lintian::Relation qw(:constants);

our (@EXPORT_OK);
BEGIN {
    @EXPORT_OK = qw(
        parse_update_python_modules
        parse_pycompile
        is_public_module
        @dist_packages_re
        classify_python_modules
        python_alt_dep
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

my $_distpackages2 = qr{
^ (?:
  usr/lib/pyshared/python2\.\d+ # python-support >= 0.90
| usr/share/pyshared # python-support >= 0.90, python-central, dh_python2
| usr/lib/python-support/[^/]+/python2\.\d+ # python-support < 0.90
| usr/share/python-support/[^/]+ # python-support < 0.90
| usr/lib/python2\.\d+/(?:site|dist)-packages # python-central, dh_python2
)
}x;

my $_public2 = qr{
^ usr/lib/python2\.\d+
| $_distpackages2
}x;

my $_distpackages3 = qr{
^ usr/lib/python3/dist-packages
}x;

my $_public3 = qr{
^ usr/lib/python3
}x;

my $_distpackages = qr{
  $_distpackages2
| $_distpackages3
}x;

my $_public = qr{
  $_public2
| $_public3
}x;

sub is_public_module {
    my ($file) = @_;
    return $file =~ $_public;
}

our @dist_packages_re = (undef, undef, $_distpackages2, $_distpackages3);

sub classify_python_modules {
    my ($package, $info) = @_;
    my $postinst = $info->control('postinst');
    my @python3paths = qw(usr/lib/python3);
    my $is_python3_package = 0;
    if ($package =~ m/^python3(?:\.\d+)(?:-.*)?$/) {
        $is_python3_package = 1;
    } else {
        my $depends = $info->relation('strong');
        my $has_python2_dep = 0;
        my $has_python3_dep = 0;
        $depends->visit(
            sub {
                if (m/^python3/) {
                    $has_python3_dep = 1;
                } elsif (m/^python/) {
                    $has_python2_dep = 1;
                }
            }, VISIT_PRED_FULL
        );
        if ($has_python3_dep and not $has_python2_dep) {
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
    my $python2regex = qr($_public2/.*[^/][.]py$);
    my $python3regex = sprintf('^(?:%s)/.*[^/][.]py$', join('|', map { quotemeta } @python3paths));
    my @python2files = ();
    my @python3files = ();
    for my $file ($info->sorted_index) {
        my $version = 0;
        next unless $info->index($file)->type eq '-';
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

sub python_alt_dep
{
    my ($major, $constraint) = @_;
    $_ = 'python | python-all | python-dev | python-all-dev';
    s/\bpython\b/python$major/g if $major > 2;
    s/\S\K(\s*)(?=\||$)/ ($constraint)$1/g if defined $constraint;
    return $_;
}

1;

# Local Variables:
# indent-tabs-mode: nil
# cperl-indent-level: 4
# End:
# vim: syntax=perl sw=4 sts=4 sr et
