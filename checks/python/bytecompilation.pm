# python::bytecompilation -- lintian check script -*- perl -*-
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

package Lintian::python::bytecompilation;

use strict;
use warnings;

use v5.10; # for the // operator

use Lintian::Relation qw();
use Lintian::Tags qw(tag);
use Lintian::Util qw(fail);

use Lintian::Contrib::Python qw(parse_update_python_modules parse_pycompile);

my $package_name_re = qr/[a-z0-9][a-z0-9.+-]+/;

my $bytecompilation_not_needed_re = qr{
  etc/
| bin/
| sbin/
| usr/bin/
| usr/games/
| usr/lib/debug/bin/
| usr/lib/debug/sbin/
| usr/lib/debug/usr/bin/
| usr/lib/debug/usr/games/
| usr/lib/debug/usr/sbin/
| usr/lib/pypy/
| usr/sbin/
| usr/share/apport/package-hooks/
| usr/share/doc/
| usr/share/jython/
| usr/share/paster_templates/
}x;

my %helper_depends = (
    'update-python-modules' => 'python-support',
    'update-python-modules/modern' => 'python-support (>= 0.90)',
    'pycentral' => 'python-central',
    'pycentral/modern' => 'python-central (>= 0.6)',
    'pycompile' => 'python (>= 2.6.5)',
    'py3compile' => 'python3 (>= 3.1.2)',
);

sub run {

my ($package, $type, $info, $proc) = @_;
if ($type eq 'source') {
    return run_source(@_);
}
my $source_package = $proc->pkg_src() // '';
my %version_map;

my $depends = $info->relation('strong');
my $version = $info->field('version');
my $self_relation = Lintian::Relation->new("$package (= $version)");
my %installed_helpers = ();
while (my ($helper, $requirement) = each %helper_depends) {
    if ($depends->implies($requirement) or $self_relation->implies($requirement)) {
        $installed_helpers{$helper} = 1;
    }
    if ($requirement =~ s/\(.*?\)//g and $depends->implies($requirement)) {
        $installed_helpers{"$helper/V"} = 1;
    }
}

my $update_version_map = sub {
    my ($regex, $versions) = @_;
    for my $file (keys %version_map) {
        if ($file =~ $regex) {
            $version_map{$file} = $versions;
        }
    }
};

for my $file ($info->sorted_index) {
    next unless $info->index($file)->type eq '-';
    next unless $file =~ /[.]py$/; # TODO: check also compressed .py files
    $version_map{$file} = 0;
}

my $postinst = $info->control('postinst');
unless (-l $postinst or not -f $postinst) {
    open(my $fp, '<', $postinst) or fail("cannot open postinst: $!");
    while (<$fp>) {
        my $helper = undef;
        s,^\s+,,;
        if (m/^update-python-modules\s+(.*)/) {
            $helper = 'update-python-modules';
            for my $arg (parse_update_python_modules($1)) {
                $arg =~ s,^/usr/share/python-support/,, and $arg =~ s,/+$,,;
                next unless $arg =~ m/^$package_name_re$/;
                my $path = "usr/share/python-support/$arg";
                my $unpacked = $info->unpacked($path);
                next if -l $unpacked;
                if (-d $unpacked) {
                    my $regex = qr{^\Q$path\E/};
                    my $versions = '2.0-'; # FIXME
                    &$update_version_map($regex, $versions);
                } elsif (-f $unpacked) {
                    if ($arg =~ m/[.]dirs$/) {
                        open(my $fp, '<', $unpacked) or fail("cannot open /$path: $!");
                        while (<$fp>) {
                            chomp;
                            s,^/+|/+$,,;
                            my $regex = qr{^\Q$_\E/};
                            my $versions = '2.0-'; # FIXME
                            &$update_version_map($regex, $versions);
                        }
                        close($fp);
                    } elsif ($arg =~ m/[.](?:private|public)/) {
                        $helper = 'update-python-modules/modern';
                        my $versions = '2.0-';
                        open(my $fp, '<', $unpacked) or fail("cannot open /$path: $!");
                        while (<$fp>) {
                            if (m,^pyversions?=([0-9.-]+)$,) {
                                $versions = $1;
                            } elsif (m,/(.+[.]py)$,) {
                                $version_map{$1} = $versions;
                            }
                        }
                        close($fp);
                    }
                }
            }
        } elsif (m/^pycentral\s+pkginstall\s+($package_name_re)\b/) {
            $helper = 'pycentral';
            my $pyc_package = $1;
            if ($pyc_package ne $package) {
                tag 'pycentral-pkginstall-for-foreign-package', $pyc_package;
            }
            my $path = "usr/share/pyshared-data/$package";
            my $unpacked = $info->unpacked($path);
            next if -l $unpacked or not -f $unpacked;
            next unless -f $unpacked;
            open(my $fp, '<', $unpacked) or fail("cannot open /$path: $!");
            $helper = 'pycentral/modern';
            my $section = '';
            my $versions = '2.0-';
            while (<$fp>) {
                chomp;
                if (m/^\[(\S+)\]$/) {
                    $section = $1;
                    next;
                }
                if ($section eq 'python-package' and m/^python-version\s*=(.+)$/) {
                    $versions = $1;
                    $versions =~ s/\s//g;
                    next;
                }
                if ($section eq 'files' and m,^/(.*)=[fY]$,) {
                    $version_map{$1} = $versions;
                }
            }
            close($fp);
        } elsif (m/^pycompile\s+(.*)/) {
            $helper = 'pycompile';
            my ($pyc_package, $default_versions, @paths) = parse_pycompile($1);
            $pyc_package //= $package;
            $default_versions //= '2.0-';
            if ($pyc_package ne $package) {
                tag 'pycompile-for-foreign-package', $pyc_package;
            }
            if (@paths) {
                # private modules
                for my $path (@paths) {
                    $path =~ s,^/+|/+$,,g;
                    my $regex = qr{^\Q$path\E/};
                    &$update_version_map($regex, $default_versions);
                }
            } else {
                # public modules
                my $regex = qr{^ (?:
                  usr/share/pyshared/
                | usr/lib/python(2\.\d+)/(?:site|dist)-packages/
                ) }x;
                for my $file (keys %version_map) {
                    if ($file =~ $regex) {
                        my $versions = $1 // $default_versions;
                        $version_map{$file} = $versions;
                    }
                }
            }
        } elsif (m/^py3compile\s+(.*)/) {
            $helper = 'py3compile';
            my ($pyc_package, $default_versions, @paths) = parse_pycompile($1);
            $pyc_package //= $package;
            $default_versions //= '3.0-';
            if ($pyc_package ne $package) {
                tag 'pycompile-for-foreign-package', $pyc_package;
            }
            if (@paths) {
                # private modules
                for my $path (@paths) {
                    $path =~ s,^/+|/+$,,g;
                    my $regex = qr{^\Q$path\E/};
                    &$update_version_map($regex, $default_versions);
                }
            } else {
                # public modules
                my $regex = qr{^usr/lib/python3/dist-packages/};
                &$update_version_map($regex, $default_versions);
            }
        }
        if ((defined $helper) and (not exists $installed_helpers{$helper})) {
            my $depends = $helper_depends{$helper};
            my $tag = 'missing-dependency-on-byte-compilation-helper';
            if (exists $installed_helpers{"$helper/V"}) {
                $tag =  'insufficient-dependency-on-byte-compilation-helper';
            }
            $helper =~ s,/.*,,;
            tag $tag, "$helper => $depends";
        }
    }
    close($fp);
}

if ($source_package =~ /^python\d\.\d+$/) {
    # custom byte-compilation code
    return;
}

for my $file (sort keys %version_map) {
    my $versions = $version_map{$file};
    if ($versions) {
        # TODO: Try to actually byte-compile
    } elsif ($file =~ m/^$bytecompilation_not_needed_re/) {
        # TODO: Check syntax for stuff in /usr/share/doc/ etc., too.
    } else {
        tag 'python-module-not-byte-compiled', $file;
    }
}

}

sub run_source {

    my ($package, $type, $info) = @_;
    for my $file ($info->sorted_index) {
        if ($file =~ /[.]py[co]$/) {
            tag 'source-contains-python-bytecode', $file;
        }
    }

}

1;

# Local Variables:
# indent-tabs-mode: nil
# cperl-indent-level: 4
# End:
# vim: syntax=perl sw=4 sts=4 sr et
