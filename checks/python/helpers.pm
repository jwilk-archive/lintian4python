# python::python::helpers -- lintian check script -*- perl -*-
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

package Lintian::python::helpers;

use strict;
use warnings;

use v5.10; # for the //= operator

use Lintian::Relation::Version qw(versions_lte);
use Lintian::Tags qw(tag);
use Lintian::Util qw(fail);

use Lintian::Contrib::Python qw(python_alt_dep);

use List::MoreUtils qw(each_array);
use Text::Levenshtein qw();

# FIXME: copied from checks/files
my @METAPKG_REGEX =
    (qr/meta[ -]?package/, qr/dummy/,
     qr/(?:dependency|empty|transitional|virtual) package/);

my $dh_python2_options = Lintian::Data->new('dh-python2-options', '\s+');
my $dh_python2_stable_ver = '2.7.3-4';

sub run {

    my ($pkg, $type, $info) = @_;
    if ($type eq 'source') {
        return run_source(@_);
    } else {
        return run_binary(@_);
    }

}

sub is_meta_pkg {
    # FIXME: this duplicates checks/files logic
    my ($info, $binpkg) = @_;
    my $description = $info->binary_field($binpkg, 'description') // '';
    for my $regex (@METAPKG_REGEX) {
        if ($description =~ /$regex/) {
            return 1;
        }
    }
    return 0;
}

sub is_doc_pkg {
    my ($info, $binpkg) = @_;
    return ($info->binary_field($binpkg, 'section') // '') eq 'doc';
}

sub is_dev_pkg {
    my ($info, $binpkg) = @_;
    return $binpkg =~ m/-(dbg|dev)$/;
}

sub is_boring_pkg {
    my ($info, $binpkg) = @_;
    return
        is_doc_pkg($info, $binpkg) ||
        is_dev_pkg($info, $binpkg) ||
        is_meta_pkg($info, $binpkg);
}

sub run_source {

    my ($pkg, $type, $info) = @_;

    my $bdepends = $info->relation('build-depends-all');

    return if $pkg =~ m/^python(?:\d\.\d)?$/;
    return if $pkg =~ m/^python\d?-(?:stdlib-extensions|profiler|old-doctools)$/;
    return if $pkg =~ m/^python3?-defaults$/;
    return if $pkg =~ m/^python-(?:central|support)$/;

    my %python_depends = ();

    my @python_version_declarations = ();
    my $pysupport_bd = $bdepends->implies('python-support');
    my $pycentral_bd = $bdepends->implies('python-central');
    if (defined (my $pv = $info->source_field('xs-python-version'))) {
        while ($pv =~ /\$\{[^}]++\}/g) {
            tag 'substitution-variable-in-xs-python-version', $pv;
        }
        if ($pv =~ /^current\b/) {
            tag 'xs-python-version-current-is-deprecated';
        }
        unless ($pysupport_bd) {
            tag 'xs-python-version-instead-of-x-python-version'
        }
        push @python_version_declarations, 'XS-Python-Version';
    }
    if ($info->field('python3-version')) {
        tag 'xs-python3-version-instead-of-x-python3-version';
    }
    if (defined(my $xpv = $info->source_field('x-python-version'))) {
        $xpv =~ s/^\s*|\s$//g;
        $xpv =~ s/\s+/ /g;
        my $vr = qr/2\.0 | 2\.[1-9]\d*/x;
        if ($xpv !~ m/^(?:>= ?$vr(?: ?, ?<< ?$vr)?|$vr|all)$/) {
            tag 'invalid-python-version-declaration', "X-Python-Version: $xpv";
        }
        push @python_version_declarations, 'X-Python-Version';
        if ($pysupport_bd) {
            tag 'x-python-version-instead-of-xs-python-version'
        }
    }
    if (defined(my $xpv = $info->source_field('x-python3-version'))) {
        $xpv =~ s/^\s*|\s$//g;
        $xpv =~ s/\s+/ /g;
        my $vr = qr/3\.0 | 3\.[1-9]\d*/x;
        if ($xpv !~ m/^(?:>= ?$vr(?: ?, ?<< ?$vr\d*)?|$vr|all)$/) {
            tag 'invalid-python-version-declaration', "X-Python3-Version: $xpv";
        }
    }
    if (-e $info->debfiles('pyversions')) {
        push @python_version_declarations, 'debian/pyversions';
    }
    if (scalar @python_version_declarations > 1) {
        tag 'multiple-python-version-declarations', "@python_version_declarations";
    }

    my @source_fields = grep { ! m/^xs?-python3?-version$/ } keys %{$info->source_field};
    my @distances = Text::Levenshtein::distance("x-python-version", @source_fields);
    my $iterator = each_array(@distances, @source_fields);
    while (my ($distance, $field) = $iterator->()) {
        if ($distance <= 3) {
            tag 'typo-in-python-version-declaration', $field, '->',
                ($pysupport_bd ? 'xs-python-version' : 'x-python-version');
        }
    }

    if (-e $info->debfiles('pycompat')) {
        tag 'debian-pycompat-is-obsolete';
    }

    my @binpkgs = sort $info->binaries;
    for my $binpkg (@binpkgs) {
        if ($info->binary_relation($binpkg, 'all')->implies('${python:Depends}')) {
            $python_depends{$binpkg} = 1;
            if ($binpkg =~ m/^python3-/) {
                tag 'python3-module-but-python-depends', $binpkg;
            }
        } else {
            if ($binpkg =~ /^python-/ and not is_boring_pkg($info, $binpkg)) {
                tag 'python-module-but-no-python-depends', $binpkg
            }
            for my $helper (qw(python-support python-central)) {
                if ($info->binary_relation($binpkg, 'all')->implies($helper)) {
                    tag 'hardcoded-dependency-on-python-helper', $helper;
                }
            }
        }
        if ($info->binary_relation($binpkg, 'all')->implies('${python3:Depends}')) {
            if ($binpkg =~ m/^python-/) {
                tag 'python-module-but-python3-depends', $binpkg;
            }
        } else {
            if ($binpkg =~ /^python3-/ and not is_boring_pkg($info, $binpkg)) {
                tag 'python3-module-but-no-python3-depends', $binpkg
            }
        }
        for my $python (qw(python python3)) {
            if ($info->binary_relation($binpkg, 'provides')->implies("\${$python:Provides}")) {
                tag 'python-provides-considered-harmful', $binpkg;
            }
            if ($info->binary_relation($binpkg, 'breaks')->implies("\${$python:Breaks}")) {
                tag 'python-breaks-is-obsolete', $binpkg;
            }
        }
        if (defined $info->binary_field($binpkg, 'xb-python-version')) {
            tag 'xb-python-version-is-deprecated', $binpkg
                unless $pycentral_bd;
        }
    }

    my $rules = $info->debfiles('rules');
    if (-l $rules or not -f $rules) {
        return;
    }
    my %req_python_version = ();
    open(my $fh, '<', $rules) or fail("cannot open rules: $!");
    while (<$fh>) {
        while (s,\\$,, and defined (my $cont = <$fh>)) {
            $_ .= $cont;
        }
        if (m,(This file was automatically generated by stdeb(?: [0-9]\S+)?),i) {
            tag 'python-stdeb-boilerplate', "debian/rules:$.", "\"$1\"";
        }
        next if /^\s*\#/;
        if (m,\bpython:Depends\b,) {
            # generated by hand
            %python_depends = ();
        } elsif (m,\bdh_python2\b,) {
            # generated by explicit call to a Python helper
            %python_depends = ();
            $req_python_version{'2.6.6-3'} //= 'dh_python2';
            for my $option ($dh_python2_options->all()) {
                my $option_re = qr/\s\Q$option\E(?:=|\s|$)/;
                if (m/$option_re/) {
                    my $version = $dh_python2_options->value($option);
                    $req_python_version{$version} //= "dh_python2 $option";
                }
            }
        } elsif (m,\bdh_(?:python|pysupport|pycentral)\b,) {
            # generated by explicit call to a Python helper
            %python_depends = ();
        } elsif (m,^include\s+/usr/share/cdbs/1/class/python-,m) {
            # generated by Python helper via CDBS
            %python_depends = ();
        } elsif (m,\bdh\b,) {
            # Lintian proper already takes care of this part.
            %python_depends = ();
        }
    }
    close($fh);
    if (keys %python_depends) {
        tag 'python-depends-but-no-python-helper', keys %python_depends;
    }

    my $droot = $info->debfiles;
    opendir(my $fp, $droot) or fail("cannot open $droot: $!");
    my $has_pyinstall = grep { m/[.]py(install|remove)$/ } readdir $fp;
    close($fp);
    if ($has_pyinstall) {
        $req_python_version{'2.6.6-6'} //= 'dh_python2 .pyinstall/.pyremove support';
    }
    foreach my $version (sort { versions_lte($a, $b) ? 1 : -1 } keys %req_python_version) {
        my $feature = $req_python_version{$version};
        my $constraint = ">= $version~";
        my $python_alt_dep = python_alt_dep(2, $constraint);
        if (not $bdepends->implies($python_alt_dep)) {
            my $tag;
            my $python_alt_dep = python_alt_dep(2);
            if (not $bdepends->implies($python_alt_dep)) {
                $tag = 'missing-build-dependency-on-python-helper';
            } elsif (versions_lte($version, $dh_python2_stable_ver)) {
                $tag = 'insufficient-build-dependency-on-python-helper';
            } else {
                $tag = 'missing-versioned-build-dependency-on-python-helper';
            }
            tag $tag, "$feature => python ($constraint)";
            last;
        }
    }
}

sub run_binary {

    my ($pkg, $type, $info) = @_;
    my $pycentral_data_path = "usr/share/pyshared-data/$pkg";
    my $pycentral_data_stat = $info->index($pycentral_data_path);
    if (defined($pycentral_data_stat) and $pycentral_data_stat->{'type'} eq '-') {
        my %files = ();
        open(my $fh, '<', $info->unpacked($pycentral_data_path)) or fail("cannot open python-central metadata: $!");
        my $files_section = 0;
        while (<$fh>) {
            if (m,^\[files\]$,) {
                $files_section = 1;
                next;
            } elsif (m,^\[,) {
                $files_section = 0;
                next;
            } elsif ($files_section) {
                if (m,^/(.+)=([fdYN])$,) {
                    my ($filename, $type) = ($1, $2);
                    $files{$filename} = 1;
                } else {
                    tag 'cannot-parse-python-central-metadata', "line $.: $_";
                    last;
                }
            }
        }
        close($fh);
        while (my ($filename, $type) = each %files) {
            my $fileinfo =
                $info->index($filename) ||
                $info->index("$filename/");
            if (not defined $fileinfo) {
                tag 'python-central-metadata-for-missing-files', $filename;
            }
        }
    }

    if (defined $info->field('python-version')) {
        tag 'xb-python-version-is-deprecated'
            unless ($info->relation('all')->implies('python-central'));
    }

    my $changelog = $info->lab_data_path('changelog');
    unless (-l $changelog or not -f $changelog) {
        my $in_lenny = check_changelog($changelog);
        if (not $in_lenny) {
            my $preinst = $info->control('preinst');
            unless (-l $preinst or not -f $preinst) {
                check_preinst($preinst);
            }
        }
    }

}

sub check_changelog {
    my ($filename) = @_;
    open (my $fh, '<', $filename) or fail("cannot open $filename");
    my $entry_no = 0;
    my $in_lenny = 0;
    while (<$fh>) {
        if (m,^\S,) {
            $entry_no += 1;
        } elsif ($entry_no < 2 and m,(source package automatically created by stdeb(?: [0-9]\S+)?),i,) {
            tag 'python-stdeb-boilerplate', "changelog:$.", "\"$1\"";
        } elsif (m/^ -- .+  [A-Z][a-z]{2}, [0-3][0-9] [A-Z][a-z]{2} ([0-9]{4}) \d{2}:\d{2}:\d{2} [+-]\d{4}$/) {
            # Lenny was released in Feb 2009, so every package in lenny must
            # have had a release in 2008.
            $in_lenny = $in_lenny || (int($1) < 2009);
        }
    }
    close $fh;
    return $in_lenny;
}

sub check_preinst {
    my ($filename) = @_;
    open (my $fh, '<', $filename) or fail("cannot open $filename: $!");
    while (<$fh>) {
        if (m/^\s*pycentral\s+pkgremove\s/) {
            tag 'unneeded-pycentral-pkgremove-in-preinst';
            last;
        }
    }
    close $fh;
}

1;

# Local Variables:
# indent-tabs-mode: nil
# cperl-indent-level: 4
# End:
# vim: syntax=perl sw=4 sts=4 sr et
