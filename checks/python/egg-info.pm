# python::egg-info -- lintian check script -*- perl -*-
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

package Lintian::python::egg_info;

use strict;
use warnings;

use v5.10; # for the //= operator

use Lintian::Data;
use Lintian::Tags qw(tag);
use Lintian::Relation ();
use Lintian::Util qw(fail);

use Lintian::Contrib::Python qw(@dist_packages_re);

my $dist_packages_re = qr{
  ( $dist_packages_re[2] )
| ( $dist_packages_re[3] )
}x;

my @PROJECTS = map { Lintian::Data->new("python$_-projects", '\|\|') } (2..3);

sub egg_version_to_regex {
    my $version = lc(shift);
    my @version_regex = split /([^0-9._]+|_)/, $version;
    @version_regex = map {
        $_ //= '';
        my $punct = /_/;
        my $alpha = /[^0-9._]/;
        if ($punct) {
            $_ = '[[:punct:]]+';
        } else {
            $_ = quotemeta($_);
        }
        if ($alpha) {
            $_ = "~?$_";
        }
        $_;
    } @version_regex;
    my $version_regex = join '', @version_regex;
    $version_regex =~ s/([[:punct:]])~/$1?~/g;
    return qr/^$version_regex$/;
}

sub run {

my ($pkg, $type, $info) = @_;

my $version = $info->field('version');
my %egg_versions = ();
my $depends = $info->relation('strong');
my $all_depends = $info->relation('all');
for my $file ($info->sorted_index) {
    next unless $info->index($file)->type eq '-';
    if ($file =~ m,$dist_packages_re/(.+)\.egg-info(?:/|$),) {
        my $py3k = int(defined $2);
        my $egg_name = $3;
        next if $egg_name =~ m,/tests?/,;
        if ($egg_name =~ m,^(?:[^-]+)-([^-]+)(?:-py(?:[^-]+)(-.+)?)?$,) {
            $egg_versions{$1} = 1;
        }
        if ($file =~ m,/requires\.txt$,) {
            my $optional_section = 0;
            open(my $fh, '<', $info->unpacked($file)) or fail("cannot open requires.txt file: $!");
            while (<$fh>) {
                if (m,^\[,) {
                    $optional_section = 1;
                    next;
                }
                m,^([-.\w]+), or next;
                my $project_name = lc $1;
                $project_name =~ y/-/_/;
                my $optional = ($optional_section or m,\[,);
                my $strict;
                ($strict) = m,==\s*([\w.-]+), unless m/,/;
                if ($PROJECTS[$py3k]->known($project_name)) {
                    my $requirement = $PROJECTS[$py3k]->value($project_name);
                    next if $requirement =~ /^(?:.*\|\s*)?\Q$pkg\E(?:\s*\|.*)?$/;
                    if (not $optional) {
                        unless ($depends->implies($requirement)) {
                            tag 'missing-requires.txt-dependency', $project_name, '=>', $requirement;
                        }
                    } else {
                        unless ($all_depends->implies($requirement)) {
                            tag 'missing-requires.txt-optional-dependency', $project_name, '=>', $requirement;
                        }
                    }
                } else {
                    my $tag = $optional ?
                        'unknown-optional-project-in-requires.txt' :
                        'unknown-project-in-requires.txt';
                    tag $tag, $project_name;
                }
                if (defined $strict) {
                    tag 'strict-versioned-dependency-in-requires.txt', "$project_name==$strict";
                }
            }
            close($fh);
        } elsif ($file =~ m,/SOURCES\.txt$,) {
            tag 'SOURCES.txt-in-binary-package';
        }
    }
}
if (scalar keys %egg_versions == 1 and defined $version) {
    my ($egg_version) = keys %egg_versions;
    my $upstream_version = $version;
    $upstream_version =~ s/-[^-]+$// # strip Debian revision
        or $upstream_version =~ s/\+b\d+$//; # strip +bN suffix (unless there was a Debian revision)
    $upstream_version =~ s/^\d+://; # strip epoch
    $upstream_version =~ s/[+]nmu\d+$//; # strip +nmuN suffix
    $upstream_version =~ s/(?:(?<=\d)|[[:punct:]]+)(?:debian|dfsg|ds|repack)[[:punct:]]*\d*$//; # strip repack suffixes
    my $version_re = egg_version_to_regex($egg_version);
    if (not $upstream_version =~ $version_re) {
        tag 'egg-info-version-mismatch', $egg_version, $upstream_version
            unless
                $upstream_version =~ /[[:punct:]](svn|cvs|git|hg|bzr|darcs)[[:punct:]]?r?\d/ or
                $upstream_version =~ /\+r\d+/ or
                $upstream_version =~ /\b20\d\d(?:0[1-9]|1[012])(?:0[1-9]|[12][0-9]|3[01])\b/;
    }
}

}

1;

# Local Variables:
# indent-tabs-mode: nil
# cperl-indent-level: 4
# End:
# vim: syntax=perl sw=4 sts=4 sr et
