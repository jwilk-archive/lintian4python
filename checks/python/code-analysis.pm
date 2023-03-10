# python::code-analysis -- lintian check script -*- perl -*-
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

package Lintian::python::code_analysis;

use strict;
use warnings;

use v5.10; # for the // operator

use Cwd qw(getcwd);

use Lintian::Relation qw(:constants);
use Lintian::Tags qw(tag);
use Lintian::Util qw(fail locate_helper_tool);

use Lintian::Contrib::Python qw(classify_python_modules);

sub run {
    my ($pkg, $type, $info, $proc) = @_;
    my $version = $info->field('version');
    my $depends = $info->relation('all');
    my $srcpkg = $proc->pkg_src() // '';
    my ($py2files, $py3files) = classify_python_modules($pkg, $info);
    my $cwd = getcwd();
    chdir $info->unpacked('.') or fail("cannot chdir to unpacked: $!");
    my @pkginfo = ($pkg, $srcpkg, $version, $depends);
    analyse(@pkginfo, $py2files, '/usr/bin/python', '-tt');
    analyse(@pkginfo, $py3files, '/usr/bin/python3') if -x '/usr/bin/python3';
    chdir $cwd or fail("cannot chdir back from unpacked: $!");
}

sub analyse {
    my ($pkg, $srcpkg, $version, $depends, $files, @interpreter) = @_;
    return unless @{$files};
    open(my $fp, '-|', @interpreter, locate_helper_tool('python/code-analysis'), @{$files}) or fail("cannot execute code-analysis helper");
    my $file;
    while (<$fp>) {
        if (m,^(\S+) (-|\d+)(?: (.+))?$,) {
            my $tag = $1;
            my $lineno = $2;
            my $extra = $3;
            my $message = $file;
            if ($lineno ne '-') {
                $message .= ":$lineno";
            }
            if (defined $extra) {
                $message .= ": $extra";
            }
            if ($tag eq 'obsolete-pil-import' and $srcpkg eq 'python-imaging') {
                next;
            }
            if ($tag eq 'embedded-code-copy') {
                if ($extra =~ m,=> python(?:\s|$), and $srcpkg =~ m,^(?:python2\.\d+|jython|pypy)$,) {
                    next;
                } else {
                    my ($depends) = $extra =~ m,=>\s*+(.++),;
                    if (not defined $depends) {
                        $depends = $extra;
                    }
                    my $self_relation = Lintian::Relation->new("$pkg (= $version)");
                    if ($self_relation->implies($depends)) {
                        next;
                    }
                }
            }
            if ($tag eq 'missing-dependency-on-ply-virtual-package') {
                my $vpkg = $extra;
                my $depends_on_vpkg = 0;
                $depends->visit(
                    sub {
                        if ($_ eq $vpkg) {
                            $depends_on_vpkg = 1;
                        }
                    }, VISIT_PRED_FULL
                );
                if (not $depends_on_vpkg) {
                    tag $tag, "$file => $vpkg";
                }
                next;
            }
            tag $tag, $message;
        } elsif (m,^# (.+)$,) {
            $file = $1;
        } else {
            chomp;
            fail("unexpected output from code-analysis helper: $_");
        }
    }
    close($fp) or fail("code-analysis helper failed");
}

1;

# Local Variables:
# indent-tabs-mode: nil
# cperl-indent-level: 4
# End:
# vim: syntax=perl sw=4 sts=4 sr et
