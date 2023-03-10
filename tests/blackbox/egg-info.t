Name: egg-info-tests
Files:
 fe866c3819599ac11908ae94bf322c1c2041b921  python-van.pydeb_1.3.3-1_all.deb
Test-Against:
 e: python-van.pydeb: unknown-project-in-requires.txt foo
 e: python-van.pydeb: unknown-project-in-requires.txt foobar
 e: python-van.pydeb: unknown-project-in-requires.txt bar
 e: python-van.pydeb: unknown-project-in-requires.txt bar
Info:
 Fixed in lintian4python 0.17.  Prior versions incorrectly emitted tags for
 .egg-info files that were parts of a test suite.

Name: SOURCES.txt-in-binary-package
Files:
 57e235913a75a8f88a71cb5ced79f4b38e032c56  python-clientcookie_1.3.0-1.2_all.deb
Test-For:
 p: python-clientcookie: SOURCES.txt-in-binary-package

Name: egg-info-version-mismatch/binnmu-suffix
Files:
 820ff879a2bcef933fd1740fc8750ad2d2a56dc7  python-buffy_0.13+b1_i386.deb
Test-Against:
 w: python-buffy: egg-info-version-mismatch 0.13 0.13+b1
Info:
 Fixed in lintian4python 0.3.  Prior versions didn't strip the +bN suffix.

Name: egg-info-version-mismatch/nmu-suffix
Files:
 61d75c0388e0606146010be21376720f1a93b14d  pygopherd_2.0.18.3+nmu2_all.deb
Test-For:
 w: pygopherd: egg-info-version-mismatch 2.0.18 2.0.18.3
Info:
 Fixed in lintian4python 0.2.  Prior versions didn't strip the +nmuN suffix.

Name: egg-info-version-mismatch/dot-rc
Files:
 551078902e56f0bb51b367c87c0f3d32a5b2f3f2  pytimechart_1.0.0~rc1-3_all.deb
Test-Against:
 w: pytimechart: egg-info-version-mismatch 1.0.0.rc1 1.0.0~rc1
Info:
 Fixed in lintian4python 0.16.1; bug #703572.

Name: missing-requires.txt-dependency
Files:
 ae76d144eeb4483c3e775adbb7e2e404e65a4a97  python-pebl_1.0.2-2_i386.deb
Test-For:
 e: python-pebl: missing-requires.txt-dependency pydot => python-pydot
 e: python-pebl: missing-requires.txt-dependency pyparsing => python-pyparsing

Name: missing-requires.txt-optional-dependency
Files:
 efb8916bd3cb7c6d921db9c66e6b1b8012232aea  python-jsonrpc2_0.3.2-3_all.deb
Test-For:
 w: python-jsonrpc2: missing-requires.txt-optional-dependency nose => python-nose
 w: python-jsonrpc2: missing-requires.txt-optional-dependency webtest => python-webtest
 w: python-jsonrpc2: missing-requires.txt-optional-dependency simplejson => python-simplejson
 w: python-jsonrpc2: missing-requires.txt-optional-dependency pastescript => python-pastescript

Name: strict-versioned-dependency-in-requires.txt
Files:
 51ef0bd17678c3b0588d70dcadf693f4f7f159ae  python-jsonpipe_0.0.8-4_all.deb
Test-For:
 e: python-jsonpipe: strict-versioned-dependency-in-requires.txt calabash==0.0.3

Name: strict-versioned-dependency-in-requires.txt/alternative
Files:
 f0f4100f440cc5369aac013af8e6a3b9d80584cb  tahoe-lafs_1.9.2-1_all.deb
Test-Against:
 e: python-jsonpipe: strict-versioned-dependency-in-requires.txt ...

Name: unknown-optional-project-in-requires.txt
Files:
 4f70701bd21059c8c327acb14c2f9e2622326e57  rst2pdf_0.16-2_all.deb
Test-For:
 w: rst2pdf: unknown-optional-project-in-requires.txt pil
 w: rst2pdf: unknown-optional-project-in-requires.txt pypdf
 w: rst2pdf: unknown-optional-project-in-requires.txt pypdf
 w: rst2pdf: unknown-optional-project-in-requires.txt pypdf
 w: rst2pdf: unknown-optional-project-in-requires.txt pythonmagick
 w: rst2pdf: unknown-optional-project-in-requires.txt svglib
 w: rst2pdf: unknown-optional-project-in-requires.txt swftools
 w: rst2pdf: unknown-optional-project-in-requires.txt wordaxe

Name: unknown-project-in-requires.txt
Files:
 d0801264b63e51d24500b8e1f2fb9e7411f2fd91  trac-odtexport_0.6.0+svn10787-2_all.deb
Test-For:
 e: trac-odtexport: unknown-project-in-requires.txt pil
