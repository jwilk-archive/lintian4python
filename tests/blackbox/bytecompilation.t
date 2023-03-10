Name: insufficient-dependency-on-byte-compilation-helper/pycompile
Files:
 e9a10ee620d264a637c5567029237001cafb84d6  cloud-init_0.7.1-3_all.deb
Test-For:
 w: cloud-init: insufficient-dependency-on-byte-compilation-helper pycompile => python (>= 2.6.5)

Name: missing-dependency-on-byte-compilation-helper/modern-pysupport
Files:
 652c79092c64756d2135982bb36d4ebcb3da2246  gettext-lint_0.4-2_all.deb
Test-For:
 e: gettext-lint: missing-dependency-on-byte-compilation-helper update-python-modules => python-support (>= 0.90)
Info:
 Fixed in lintian4python 0.2.  Prior versions incorrectly emitted:
  e: ...: missing-dependency-on-byte-compilation-helper update-python-modules/modern => ...

Name: missing-dependency-on-byte-compilation-helper/pysupport-self-dependency
Files:
 810d860b7ec68ad2219e1baf151d64377c316a01  python-support_1.0.14_all.deb
Test-Against:
 e: python-support: missing-dependency-on-byte-compilation-helper update-python-modules => python-support
Info:
 Fixed in lintian4python 0.2.  Prior versions incorrectly suggested that
 python-support should have a self-dependency.

Name: python-module-not-byte-compiled/pysupport-post-install
Files:
 810d860b7ec68ad2219e1baf151d64377c316a01  python-support_1.0.14_all.deb
Test-Against:
 e: python-support: python-module-not-byte-compiled usr/share/python-support/private/pysupport.py
Info:
 Fixed in lintian4python 0.2.  Prior versions incorrectly assumed that
 update-python-modules with -p/--post-install is not sufficient for
 byte-compilation.

Name: python-module-not-byte-compiled/etc
Files:
 3c702ae5eb4a3a46b8a35b77117382aaea8907fa  ezmlm-browse_0.10-3_i386.deb
Test-Against:
 e: ezmlm-browse: python-module-not-byte-compiled etc/ezmlm-browse/config.py
Info:
 Fixed in lintian4python 0.8.1.

Name: python-module-not-byte-compiled/pypy
Files:
 25f1111452e69d26046ef52332b2b73b66489086  pypy-lib_1.9+dfsg-2_all.deb
Test-Against:
 e: pypy-lib: python-module-not-byte-compiled usr/lib/pypy/lib_pypy/...
Info:
 Fixed in lintian4python 0.8.1.

Name: python-module-not-byte-compiled/jython
Files:
 e1a83f42755c81542f0416de069825d2ed9b3bd8  jython_2.5.2-1_all.deb
Test-Against:
 e: jython: python-module-not-byte-compiled usr/share/jython/...
Info:
 Fixed in lintian4python 0.8.1.

Name: python-module-not-byte-compiled/public-python2
Files:
 32fc3d93837bcf15d08377ee70a0b8f6edd47794  python-nflog_0.1-2_i386.deb
Test-For:
 e: python-nflog: python-module-not-byte-compiled usr/lib/python2.6/dist-packages/nflog.py
 e: python-nflog: python-module-not-byte-compiled usr/lib/python2.7/dist-packages/nflog.py

Name: python-module-not-byte-compiled/public-python3
Files:
 d1ab0a819dac9f9df7d2a698595cd06d0180d7ed  python-hivex_1.3.5-2_i386.deb
Test-For:
 e: python-hivex: python-module-not-byte-compiled usr/lib/python3/dist-packages/hivex.py

Name: source-contains-python-bytecode
Files:
 97db53569010102d48d731152099016d73529ab2  wicd_1.7.2.4-4.dsc
 043321f59bef1eb1d1e49c4c14316deca7e5e1c6  wicd_1.7.2.4.orig.tar.gz
 d1460ad1f5fd43008367831e6e0f448b8200cea3  wicd_1.7.2.4-4.debian.tar.gz
Test-For:
 w: wicd source: source-contains-python-bytecode curses/curses_misc.pyc
 w: wicd source: source-contains-python-bytecode curses/netentry_curses.pyc
 w: wicd source: source-contains-python-bytecode curses/prefs_curses.pyc
