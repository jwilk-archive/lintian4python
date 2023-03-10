# python::documentation -- lintian check script -*- perl -*-
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

package Lintian::python::documentation;

use strict;
use warnings;

use v5.10; # for the // operator

use Lintian::Tags qw(tag);
use Lintian::Util qw(slurp_entire_file);

use File::Basename qw(basename);

use URI::Split qw(uri_split);

sub uri_is_local
{
    my ($scheme, $auth, $path, $query, $fragment) = @_;
    return not (
        defined $scheme or
        defined $auth or
        ($path // '') =~ m,^/,
    );
}

sub uri_is_concatenable
{
    my ($scheme, $auth, $path, $query, $fragment) = @_;
    return not (
        defined $fragment or
        defined $query
    );
}

sub uri_path
{
    my ($scheme, $auth, $path, $query, $fragment) = @_;
    return $path;
}

sub check_js
{
    my ($info, $html_filename, $directory, $js_url) = @_;
    my @js_url = uri_split($js_url);
    if (not uri_is_local(@js_url)) {
        if ($js_url =~ m,/usr/share/javascript/[^/]+/[^/]+\.js$,) {
            # TODO: Check if it really exists.
            return '';
        }
        tag 'search.html-references-non-local-file', $html_filename, '->', $js_url;
        return '';
    }
    my $result = my $js_filename = uri_path(@js_url);
    $js_filename = "$directory/$js_filename";
    1 while $js_filename =~ s,(?:^|/+)[^/]+/+\.\./+,/,;
    if (defined $info->index($js_filename)) {
        if ($info->index($js_filename)->type eq '-') {
            my $js_basename = basename($js_filename);
            if ($js_basename eq 'doctools.js') {
                my $js = slurp_entire_file($info->unpacked($js_filename));
                if ($js =~ m/\bjQuery\.className\b/) {
                    tag 'sphinx-js-incompatible-with-jquery-1.4', $js_filename;
                }
            } elsif ($js_basename eq 'searchtools.js') {
                my $js = slurp_entire_file($info->unpacked($js_filename));
                if ($js !~ /"text"/) {
                    tag 'sphinx-js-incompatible-with-jquery-1.5', $js_filename;
                }
                if ($js =~ /({{ .*? }})/) {
                    tag 'sphinx-static-file-with-jinja2-templates', $js_filename, $1;
                }
            }
        }
    } else {
        my $tag = 'js-file-referenced-by-search.html-does-not-exist';
        if (defined $info->index("$js_filename.gz")) {
            $js_filename .= '.gz';
            $tag = 'js-file-referenced-by-search.html-is-compressed';
        }
        tag $tag, $js_filename, "($html_filename)";
    }
    return $result;
}

sub check_css {
    my ($info, $html_filename, $directory, $css_url) = @_;
    my @css_url = uri_split($css_url);
    if (not uri_is_local(@css_url)) {
        tag 'search.html-references-non-local-file', $html_filename, '->', $css_url;
        return;
    }
    my $css_filename = uri_path(@css_url);
    $css_filename = "$directory/$css_filename";
    $css_filename =~ s,[^/]+$,default.css,;
    1 while $css_filename =~ s,(?:^|/+)[^/]+/+\.\./+,/,;
    my $css_info = $info->index($css_filename);
    return unless defined $css_info;
    return unless $css_info->type eq '-';
    my $css = slurp_entire_file($info->unpacked($css_filename));
    if ($css =~ m/({{ theme_.*? }})/) {
        tag 'sphinx-static-file-with-jinja2-templates', $css_filename, $1;
    }
}

sub check_searchindex {
    my ($info, $directory, $searchindex_filename) = @_;
    $searchindex_filename = "$directory/$searchindex_filename";
    defined $info->index($searchindex_filename) or return;
    $info->index($searchindex_filename)->type eq '-' or return;
    my $searchindex = slurp_entire_file($info->unpacked($searchindex_filename));
    if ($searchindex =~ m{^Search\.setIndex\(.*?filenames:\["(.*?)"\].*\)$}) {
        $searchindex = $1;
        my @searchindex = split(/","/, $searchindex);
        for my $filename (@searchindex) {
            $filename = "$directory/_sources/$filename.txt";
            if (not defined $info->index($filename)) {
                my $tag = 'rst-source-referenced-by-searchindex.js-does-not-exist';
                if (defined $info->index("$filename.gz")) {
                    $filename .= '.gz';
                    $tag = 'rst-source-referenced-by-searchindex.js-is-compressed';
                }
                tag $tag, $filename, "($searchindex_filename)";
            }
        }
    } else {
        tag 'cannot-parse-sphinx-searchindex.js', $searchindex_filename;
    }
}

sub run {
    my ($pkg, $type, $info) = @_;
    if ($type eq 'source') {
        return run_source($pkg, $info)
    } else {
        return run_binary($pkg, $info)
    }
}

sub run_binary {
    my ($pkg, $info) = @_;
    for my $html_filename ($info->sorted_index) {
        next unless $info->index($html_filename)->type eq '-';
        next unless my ($directory) = $html_filename =~ m,^(.*)/search\.html$,;
        my $html = slurp_entire_file($info->unpacked($html_filename));
        $html =~ m/\svar\s+DOCUMENTATION_OPTIONS\s*=/ or next;
        my ($root_url) = $html =~ m{\sURL_ROOT:\s*'([^']*)'};
        defined $root_url or next;
        my $evidence = 0;
        $evidence += 1 * ($html =~ m/\sVERSION:/);
        $evidence += 2 * ($html =~ m/\sCOLLAPSE_(MOD)?INDEX:/);
        $evidence += 1 * ($html =~ m/\sFILE_SUFFIX:/);
        my ($has_source) = $html =~ m{\sHAS_SOURCE:\s*(true|false)};
        $evidence += 2 * (defined $has_source);
        $evidence >= 4 or next;
        $has_source = ($has_source // '') eq 'true';
        my @root_url = uri_split($root_url);
        {
            my $skip = 0;
            if (not uri_is_local(@root_url)) {
                tag 'search.html-with-non-local-root-url', $html_filename, '->', $root_url;
                $skip = 1;
            }
            if (not uri_is_concatenable(@root_url)) {
                tag 'search.html-with-invalid-root-url', $html_filename, '->', $root_url;
                $skip = 1;
            }
            next if $skip;
        }
        my $searchindex_path = undef;
        $html =~ s/<!--.*?-->//g; # strip comments
        while ($html =~ m{<script type="text/javascript" src="([^"]++)"></script>}g) {
            my $js_path = check_js($info, $html_filename, $directory, $1);
            if (basename($js_path) eq 'searchindex.js') {
                $searchindex_path = $js_path;
            }
        }
        my %css_directories = ();
        while ($html =~ m{<link rel="stylesheet" href="([^"]++)"}g) {
            my $path = my $dir = $1;
            $dir =~ s,[^/]*$,,;
            $css_directories{$dir} = $path;
        }
        foreach (sort values %css_directories) {
            check_css($info, $html_filename, $directory, $_);
        }
        if ($html =~ m/\QjQuery(function() { Search.loadIndex("searchindex.js"); });\E/) {
            $searchindex_path = check_js($info, $html_filename, $directory, 'searchindex.js') || $searchindex_path;
        }
        if (defined $searchindex_path) {
            if ($has_source) {
                check_searchindex($info, $directory, $searchindex_path);
            }
        } else {
            tag 'search.html-does-not-load-search-index', $html_filename;
        }
        for my $cruft (qw(.buildinfo .doctrees/ _static/websupport.js)) {
            my $filename = "$directory/$cruft";
            if (defined $info->index($filename)) {
                tag 'sphinx-cruft-in-binary-package', $filename;
            }
        }
    }
}

sub run_source {
    my ($pkg, $info) = @_;
    for my $file ($info->sorted_index) {
        if ($file =~ m,(environment[.]pickle|[.]doctree)$,) {
            tag 'source-contains-sphinx-cache', $file;
        }
    }
}

1;

# Local Variables:
# indent-tabs-mode: nil
# cperl-indent-level: 4
# End:
# vim: syntax=perl sw=4 sts=4 sr et
