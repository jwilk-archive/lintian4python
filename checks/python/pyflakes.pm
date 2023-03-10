# python::pyflakes -- lintian check script -*- perl -*-
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

package Lintian::python::pyflakes;

use strict;
use warnings;

use Cwd qw(getcwd);

use Lintian::Tags qw(tag);
use Lintian::Util qw(fail locate_helper_tool);

use Lintian::Contrib::Python qw(classify_python_modules is_public_module);

sub run {
    my ($pkg, $type, $info) = @_;
    my ($py2files, $py3files) = classify_python_modules($pkg, $info);
    my $cwd = getcwd();
    chdir $info->unpacked('.') or fail("cannot chdir to unpacked: $!");
    analyse($py2files, '/usr/bin/python');
    analyse($py3files, '/usr/bin/python3', '-B') if -x '/usr/bin/python3';
    chdir $cwd or fail("cannot chdir back from unpacked: $!");
}

sub analyse {
    my ($pyfiles, @interpreter) = @_;
    return unless @{$pyfiles};
    open(my $fp, '-|', @interpreter, locate_helper_tool('python/pyflakes'), @{$pyfiles}) or fail("cannot execute pyflakes helper");
    my %underscores = ();
    my %import_star = ();
    my $file;
    while (<$fp>) {
        if (m,^(pyflakes-\S+) (.*),) {
            my $tag = $1;
            my $rest = $2;
            if ($tag eq 'pyflakes-undefined-name' and $rest =~ m/ _$/ and not is_public_module($file)) {
                if (not exists ($underscores{$file})) {
                    tag "pyflakes-undefined-name-underscore", "$file:$rest";
                    $underscores{$file} = 1;
                }
            } elsif ($tag eq 'pyflakes-import-star-used') {
                if (not exists ($import_star{$file})) {
                    tag $tag, "$file:$rest";
                    $import_star{$file} = 1;
                }
            } else {
                if ($tag eq 'pyflakes-late-future-import') {
                    $rest =~ s/(?<= )\['//g and
                    $rest =~ s/'\]$//g and
                    $rest =~ s/', '//g;
                }
                tag $tag, "$file:$rest";
            }
        } elsif (m,^# (.+)$,) {
            $file = $1;
        } else {
            # We used to emit syntax-error here, but now it's taken care by
            # the code-analysis check.
        }
    }
    close($fp) or fail("pyflakes helper failed");
}

1;

# Local Variables:
# indent-tabs-mode: nil
# cperl-indent-level: 4
# End:
# vim: syntax=perl sw=4 sts=4 sr et
