Name: missing-dependency-for-import/setuptools-implies-pkg-resources
Files:
 c951f8198160c8c096130fc5574d2df8ce7cf5a4  flashbake_0.26.2-4_all.deb
Test-Against:
 e: flashbake: missing-dependency-for-import pkg_resources (usr/bin/flashbakeall usr/bin/flashbake) => python-pkg-resources
Info:
 Fixed in lintian4python 0.2.  Prior versions emitted
  e: ...: missing-dependency-for-import pkg_resources ...
 even though the package depended on python-setuptools.

Name: missing-dependency-for-import/python-pkg-resources
Files:
 0da1b2f51b00e32f0bba9ca1de941d262d6f2ba1  python-html2text_3.200.3-1_all.deb
Test-For:
 e: python-html2text: missing-dependency-for-import pkg_resources (usr/bin/html2markdown.py2) => python-pkg-resources

Name: missing-dependency-for-import/python3-pkg-resources
Files:
 22e4c98018014db38f3b230f0f1b1ae76a0ca725  python3-html2text_3.200.3-1_all.deb
Test-For:
 e: python3-html2text: missing-dependency-for-import pkg_resources (usr/bin/html2markdown.py3) => python3-pkg-resources
