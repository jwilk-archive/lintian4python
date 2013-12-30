Name: assertion-always-true
Files:
 57e235913a75a8f88a71cb5ced79f4b38e032c56  python-clientcookie_1.3.0-1.2_all.deb
Test-For:
 w: python-clientcookie: assertion-always-true usr/share/pyshared/ClientCookie/_MSIECookieJar.py:261

Name: embedded-code-copy/beautifulsoup
Files:
 98406b9308b950d6538ca2e32bdc67f3d2ea54b9  python-imdbpy_4.9-1_i386.deb
Test-For:
 e: python-imdbpy: embedded-code-copy usr/share/pyshared/imdb/parser/http/bsouplxml/_bsoup.py: BeautifulSoup => python-beautifulsup

Name: embedded-code-copy/configparser
Files:
 910c1858deed9418a37f00099b2a03bb8b9367dc  mucous_0.2+svn20100315.r1208-2_all.deb
Test-For:
 e: mucous: embedded-code-copy usr/share/pyshared/pymucous/ConfigParser.py: ConfigParser => python

Name: embedded-code-copy/argparse
Files:
 25e370e2ad50bff7a3e6a73abfc5f724ba92ec8c  pgxnclient_1.0.3-1_all.deb
Test-For:
 e: pgxnclient: embedded-code-copy usr/share/pyshared/pgxnclient/utils/argparse.py: argparse => python (>= 2.7) | python-argparse

Name: embedded-code-copy/configobj
Files:
 20624eb08e8be88ac0694a37fa03c82c8be217bb  rest2web_0.5.2~alpha+svn-r248-2_all.deb
Test-For:
 e: rest2web: embedded-code-copy usr/share/pyshared/rest2web/pythonutils/configobj.py: configobj => python-configobj

Name: embedded-code-copy/doctest
Files:
 f34104077e8589cf763aee73d469f26e9d3cd5ef  python-setuptools_0.6.24-1_all.deb
Test-For:
 e: python-setuptools: embedded-code-copy usr/share/pyshared/setuptools/tests/doctest.py: doctest => python

Name: embedded-code-copy/ply
Files:
 5a1e8acd9ed5869af8b02cf1d95ceca2435519cd  python-pyke_1.1.1-1_all.deb
Test-For:
 e: python-pyke: embedded-code-copy usr/share/pyshared/pyke/krb_compiler/ply/lex.py: ply.lex => python-ply
 e: python-pyke: embedded-code-copy usr/share/pyshared/pyke/krb_compiler/ply/yacc.py: ply.yacc => python-ply

Name: embedded-code-copy/pexpect+optparse
Files:
 7875c3bc405e158698531c64af84dc532c92ed63  python-smartpm_1.4-2_i386.deb
Test-For:
 e: python-smartpm: embedded-code-copy usr/share/pyshared/smart/util/optparse.py: optparse => python (>= 2.3)
 e: python-smartpm: embedded-code-copy usr/share/pyshared/smart/util/pexpect.py: pexpect => python-pexpect

Name: embedded-code-copy/pyparsing
Files:
 388a4f24d66885ab300ba924c76e85facf5a1eb9  mitmproxy_0.8-2_i386.deb
Test-For:
 e: mitmproxy: embedded-code-copy usr/share/pyshared/libmproxy/contrib/pyparsing.py: pyparsing => python-pyparsing

Name: embedded-code-copy/sets
Files:
 bb77ca977f202a011545fabefd46786eda30513c  spambayes_1.0.4-5.1_all.deb
Test-For:
 e: spambayes: embedded-code-copy usr/share/pyshared/spambayes/compatsets.py: sets => python (>= 2.3)

Name: embedded-code-copy/smartypants
Files:
 4f70701bd21059c8c327acb14c2f9e2622326e57  rst2pdf_0.16-2_all.deb
Test-For:
 e: rst2pdf: embedded-code-copy usr/share/pyshared/rst2pdf/smartypants.py: smartypants => python-smartypants

Name: embedded-code-copy/subprocess
Files:
 5492e75e51e26a8c15ce10a7f15f1aadd86c9814  sshuttle_0.54-2_all.deb
Test-For:
 e: sshuttle: embedded-code-copy usr/lib/sshuttle/compat/ssubprocess.py: subprocess => python (>= 2.4)

Name: embedded-code-copy/uuid+youtube-dl
Files:
 9b97da0e902ff54c627de6f5703ecef7ebcad3cd  python-coherence_0.6.6.2-6_all.deb
Test-For:
 e: python-coherence: embedded-code-copy usr/share/pyshared/coherence/extern/uuid/uuid.py: uuid => python (>= 2.5)
 e: python-coherence: embedded-code-copy usr/share/pyshared/coherence/extern/youtubedl/youtubedl.py: youtube-dl

Name: embedded-code-copy/textwrap
Files:
 6e5340d36e03eee1dbe94eabbd087514fe3c6008  translate-toolkit_1.9.0-2_all.deb
Test-For:
 e: translate-toolkit: embedded-code-copy usr/share/pyshared/translate/misc/textwrap.py: textwrap => python (>= 2.3)

Name: except-shadows-builtin
Files:
 ae76d144eeb4483c3e775adbb7e2e404e65a4a97  python-pebl_1.0.2-2_i386.deb
Test-For:
 e: python-pebl: except-shadows-builtin usr/share/pyshared/pebl/network.py:69: ValueError

Name: except-without-exception-type
Files:
 2bfb202a9e17e12aa4bb6dacf80612e33ef4d453  python-dput_1.0_all.deb
Test-For:
 x: python-dput: except-without-exception-type usr/share/pyshared/dput/uploaders/sftp.py:51

Name: hardcoded-errno-value
Files:
 2bfb202a9e17e12aa4bb6dacf80612e33ef4d453  python-dput_1.0_all.deb
Test-For:
 w: python-dput: hardcoded-errno-value usr/share/pyshared/dput/uploaders/sftp.py:222: 13 -> errno.EACCES

Name: inconsistent-use-of-tabs-and-spaces-in-indentation
Files:
 efa5529f00662e26dd6d0609e1603e08de5bfe32  python-slides_1.0.1-13_all.deb
Test-For:
 w: python-slides: inconsistent-use-of-tabs-and-spaces-in-indentation usr/share/pyshared/slides.py:39

Name: missing-dependency-on-ply-virtual-package/py2
Files:
 2c415db11026b30293cbca029bbbe15f3b5494dd  python-pycparser_2.09.1+dfsg-1_all.deb
Test-For:
 e: python-pycparser: missing-dependency-on-ply-virtual-package usr/share/pyshared/pycparser/lextab.py => python-ply-lex-3.4
 e: python-pycparser: missing-dependency-on-ply-virtual-package usr/share/pyshared/pycparser/yacctab.py => python-ply-yacc-3.2

Name: missing-dependency-on-ply-virtual-package/py3
Files:
 a4474dd62d912f1d3f84c5559f48cff050fd15a6  python3-pycparser_2.09.1+dfsg-1_all.deb
Test-For:
 e: python3-pycparser: missing-dependency-on-ply-virtual-package usr/lib/python3/dist-packages/pycparser/lextab.py => python3-ply-lex-3.4
 e: python3-pycparser: missing-dependency-on-ply-virtual-package usr/lib/python3/dist-packages/pycparser/yacctab.py => python3-ply-yacc-3.2

Name: missing-dependency-on-ply-virtual-package/py2-okay
Files:
 e0d61f533a2b840ef879d8a15a417336e80b62fc  python-pyke_1.1.1-3_all.deb
Test-Against:
 e: python-pyke: missing-dependency-on-ply-virtual-package ...

Name: mkstemp-file-descriptor-leak/1
Files:
 e9bcd22e0aebc1be9dd604c275f9df00f22d5e74  lfm_2.3-1_all.deb
Test-For:
 w: lfm: mkstemp-file-descriptor-leak usr/share/lfm/lfm/files.py:376
 w: lfm: mkstemp-file-descriptor-leak usr/share/lfm/lfm/pyview.py:218

Name: mkstemp-file-descriptor-leak/2
Files:
 47fcf1b11a4f2cc1f2cc9a72ff93014420b6a425  wajig_2.7.3_all.deb
Test-For:
 w: wajig: mkstemp-file-descriptor-leak usr/share/wajig/commands.py:134
 w: wajig: mkstemp-file-descriptor-leak usr/share/wajig/commands.py:944
 w: wajig: mkstemp-file-descriptor-leak usr/share/wajig/util.py:104
 w: wajig: mkstemp-file-descriptor-leak usr/share/wajig/util.py:171
 w: wajig: mkstemp-file-descriptor-leak usr/share/wajig/util.py:372

Name: obsolete-pil-import/python2
Files:
 cf0f365f88204468ff367903e9a5d001df870114  didjvu_0.2.3-2_all.deb
Test-For:
 e: didjvu: obsolete-pil-import usr/share/didjvu/lib/gamera_extra.py:24: Image

Name: obsolete-pil-import/python2/try-except
Files:
 fb39aa66a227c74e985a08a1a842d4b73bce5954  python-docutils_0.10-1_all.deb
Test-Against:
 e: python-docutils: obsolete-pil-import usr/share/pyshared/docutils/parsers/rst/directives/images.py:23: Image
 e: python-docutils: obsolete-pil-import usr/share/pyshared/docutils/writers/html4css1/__init__.py:28: Image
 e: python-docutils: obsolete-pil-import usr/share/pyshared/docutils/writers/odf_odt/__init__.py:69: Image

Name: obsolete-pil-import/python3/try-except
Files:
 b84c021199d6a48e78dc406fb8c3bf6fca4a9d7b  python3-docutils_0.10-1_all.deb
Test-Against:
 e: python3-docutils: obsolete-pil-import usr/lib/python3/dist-packages/docutils/parsers/rst/directives/images.py:23: Image
 e: python3-docutils: obsolete-pil-import usr/lib/python3/dist-packages/docutils/writers/html4css1/__init__.py:28: Image
 e: python3-docutils: obsolete-pil-import usr/lib/python3/dist-packages/docutils/writers/odf_odt/__init__.py:69: Image

Name: regexp-overlapping-ranges
Files:
 24626e13b27aee642eb57e8b9abcfe106da2d6fb  python-enchant_1.6.5-2_all.deb
Test-For:
 e: python-enchant: regexp-overlapping-ranges usr/share/pyshared/enchant/tokenize/__init__.py:426: A-z a-z

Name: string-exception/raise
Files:
 3cff5aa6eefba08867fdbce973e283e2b3178173  bittorrent_3.4.2-11.4_all.deb
Test-For:
 e: bittorrent: string-exception usr/share/pyshared/BitTorrent/StorageWrapper.py:386
 e: bittorrent: string-exception usr/share/pyshared/BitTorrent/StorageWrapper.py:395

Name: string-exception/except
Files:
 3da9cd9b0211bf8caac9717b116cbedd0256c487  pyftpd_0.8.5+nmu1_all.deb
Test-For:
 e: pyftpd: string-exception usr/share/pyftpd/pyftpd.py:125

Name: string-formatting-error
Files:
 910c1858deed9418a37f00099b2a03bb8b9367dc  mucous_0.2+svn20100315.r1208-2_all.deb
Test-For:
 e: mucous: string-formatting-error usr/share/pyshared/pymucous/MucousShares.py:653: not all arguments converted during string formatting
 e: mucous: string-formatting-error usr/share/pyshared/pymucous/MucousShares.py:658: not all arguments converted during string formatting
 e: mucous: string-formatting-error usr/share/pyshared/pymucous/MucousShares.py:663: not all arguments converted during string formatting
 e: mucous: string-formatting-error usr/share/pyshared/pymucous/MucousShares.py:675: not all arguments converted during string formatting

Name: syntax-error
Files:
 1e7a29406299962ec9cf043c57c291d61b68ffa5  python-pydoctor_0.2-4_all.deb
Test-For:
 e: python-pydoctor: syntax-error usr/share/python-support/python-pydoctor/pydoctor/ast_pp.py:116: invalid syntax

Name: syntax-error/tokenization
Files:
 3e8b3444653bfd2d72f6b359555917b0de59d70b  gnuspool_1.7_i386.deb
Test-For:
 e: gnuspool: syntax-error usr/share/gnuspool/ptrinstall/ptrinstall.py: compile() expected string without null bytes
Info:
 Check if we handle token-level syntax errors correctly.

Name: syntax-error/py-tmpl
Files:
 c7b7e163f492a0c74227eeb2755ce0747ff51727  python-migrate_0.7.2-3_all.deb
Test-Against:
 e: python-migrate: syntax-error usr/share/pyshared/migrate/...py_tmpl...
Info:
 *.py_tmpl files are code templates, so they could legitimately contain syntax
 errors.

Name: code-analysis/python3-encoding
Files:
 85d98547318e7737d8cf5f89ab7b935b3781b3fc  python3-pipeline_0.1.3-3_all.deb
Test-Check:
 python/code-analysis
