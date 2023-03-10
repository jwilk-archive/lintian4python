Name: usr-bin-env-python-shebang
Files:
 fa1de0eadb33143ce8df66d70f61652d0d493334  autojump_20-2_all.deb
Test-For:
 w: autojump: usr-bin-env-python-shebang usr/bin/autojump

Name: versioned-python-shebang
Files:
 b3b67527ef0a418d40d162620ca12af3a7539f84  snimpy_0.6.3-1_i386.deb
Test-For:
 i: snimpy: versioned-python-shebang usr/bin/snimpy /usr/bin/python2.7

Name: versioned-python-shebang/in-versioned-package-1
Files:
 7756353c1acbe274871d7a2b64486999d8b2524e  python2.7-examples_2.7.3~rc2-2.1_all.deb
Test-Against:
 i: python2.7-examples: versioned-python-shebang usr/share/doc/python2.7/examples/... /usr/bin/python2.7
Info:
 Fixed in lintian4python 0.2.  Prior versions incorrectly emitted:
  i: pythonX.Y-...: versioned-python-shebang ... /usr/bin/pythonX.Y

Name: versioned-python-shebang/in-versioned-package-2
Files:
 476952c492181cbae7f1111939126733d234176b  idle-python2.7_2.7.3-1_all.deb
Test-Against:
 i: idle-python2.7: versioned-python-shebang usr/lib/python2.7/idlelib/PyShell.py /usr/bin/python2.7
Info:
 Fixed in lintian4python 0.6.  Prior versions incorrectly emitted:
  i: idle-pythonX.Y-...: versioned-python-shebang ... /usr/bin/pythonX.Y
