Name: pyflakes/tokenization
Files:
 3e8b3444653bfd2d72f6b359555917b0de59d70b  gnuspool_1.7_i386.deb
Test-Check:
 python/pyflakes
Info:
 Fixed in lintian4python 0.3.  Prior versions incorrectly died with internal
 error if a Python file had token-level syntax errors.

Name: pyflakes-import-star-used
Files:
 3c702ae5eb4a3a46b8a35b77117382aaea8907fa  ezmlm-browse_0.10-3_i386.deb
Test-For:
 x: ezmlm-browse: pyflakes-import-star-used etc/ezmlm-browse/config.py:1: globals
 x: ezmlm-browse: pyflakes-import-star-used usr/lib/ezmlm-browse/commands/author.py:1: globals
 x: ezmlm-browse: pyflakes-import-star-used usr/lib/ezmlm-browse/commands/configure.py:3: globals
 x: ezmlm-browse: pyflakes-import-star-used usr/lib/ezmlm-browse/commands/feed.py:1: globals
 x: ezmlm-browse: pyflakes-import-star-used usr/lib/ezmlm-browse/commands/lists.py:1: globals
 x: ezmlm-browse: pyflakes-import-star-used usr/lib/ezmlm-browse/commands/monthbydate.py:1: globals
 x: ezmlm-browse: pyflakes-import-star-used usr/lib/ezmlm-browse/commands/monthbythread.py:1: globals
 x: ezmlm-browse: pyflakes-import-star-used usr/lib/ezmlm-browse/commands/months.py:1: globals
 x: ezmlm-browse: pyflakes-import-star-used usr/lib/ezmlm-browse/commands/search.py:1: globals
 x: ezmlm-browse: pyflakes-import-star-used usr/lib/ezmlm-browse/commands/showmsg.py:1: globals
 x: ezmlm-browse: pyflakes-import-star-used usr/lib/ezmlm-browse/commands/showthread.py:1: globals
 x: ezmlm-browse: pyflakes-import-star-used usr/lib/ezmlm-browse/commands/threadindex.py:1: globals
 x: ezmlm-browse: pyflakes-import-star-used usr/lib/ezmlm-browse/ezmlm.py:9: globals
 x: ezmlm-browse: pyflakes-import-star-used usr/lib/ezmlm-browse/feedgen.py:1: globals
 x: ezmlm-browse: pyflakes-import-star-used usr/lib/ezmlm-browse/globalfns.py:7: globals
 x: ezmlm-browse: pyflakes-import-star-used usr/lib/ezmlm-browse/main.py:14: globals

Name: pyflakes-redefined-in-list-comp
Files:
 499bdc2229ec4b511921986d1b53fb6a50522275  alot_0.3.3-1_all.deb
Test-For:
 i: alot: pyflakes-redefined-in-list-comp usr/share/alot/alot/completion.py:414: cmd line 319

Name: pyflakes-redefined-while-unused
Files:
 954d37c651029446fea3889a67c0bdf4ff598d31  atheist_0.20100717-1_all.deb
Test-For:
 i: atheist: pyflakes-redefined-while-unused usr/share/pyshared/atheist/utils.py:12: logging line 9

Name: pyflakes-undefined-export
Files:
 4f70701bd21059c8c327acb14c2f9e2622326e57  rst2pdf_0.16-2_all.deb
Test-For:
 w: rst2pdf: pyflakes-undefined-export usr/share/pyshared/rst2pdf/tenjin.py:46: html

Name: pyflakes-undefined-local
Files:
 efb8916bd3cb7c6d921db9c66e6b1b8012232aea  python-jsonrpc2_0.3.2-3_all.deb
Test-For:
 e: python-jsonrpc2: pyflakes-undefined-local usr/share/pyshared/jsonrpc2/gae.py:32: name line 30

Name: pyflakes-undefined-name
Files:
 cf01845b4ad64ed44b118bd097c717d9ccfe6dcd  python-argvalidate_0.9.0-1_all.deb
Test-For:
 e: python-argvalidate: pyflakes-undefined-name usr/share/python-support/python-argvalidate/argvalidate.py:325: DecoratorKeyLengthException
 e: python-argvalidate: pyflakes-undefined-name usr/share/python-support/python-argvalidate/argvalidate.py:561: argvalidate_kwarg_as_arg

Name: pyflakes-undefined-name-underscore
Files:
 f8a8b0922e647ee7e9c63217b1a1f3ab0f5af911  rhythmbox-ampache_0.11.1-1_all.deb
Test-For:
 x: rhythmbox-ampache: pyflakes-undefined-name-underscore usr/lib/rhythmbox/plugins/ampache/AmpacheBrowser.py:135: _
 x: rhythmbox-ampache: pyflakes-undefined-name-underscore usr/lib/rhythmbox/plugins/ampache/__init__.py:66: _
Test-Against:
 e: rhythmbox-ampache: pyflakes-undefined-name ...: _
Info:
 Fixed in lintian4python 0.5.

Name: pyflakes-unused-import
Files:
 a0452f86380bf557d6989897a78f3d76ed2875a8  python-sqlparse_0.1.4-1_all.deb
Test-For:
 p: python-sqlparse: pyflakes-unused-import usr/bin/sqlformat:9: os

Name: pyflakes-unused-variable
Files:
 cf0f365f88204468ff367903e9a5d001df870114  didjvu_0.2.3-2_all.deb
Test-For:
 p: didjvu: pyflakes-unused-variable usr/share/didjvu/lib/didjvu.py:307: bytes_in
