Name: js-file-referenced-by-search.html-does-not-exist
Files:
 9dfd4e1efc9552dc5c9170872e7db112e289e40a  python-flaskext.wtf_0.6-1_all.deb
Test-For:
 w: python-flaskext.wtf: js-file-referenced-by-search.html-does-not-exist usr/share/doc/python-flaskext.wtf/html/_static/jquery.js (usr/share/doc/python-flaskext.wtf/html/search.html)

Name: js-file-referenced-by-search.html-is-compressed
Files:
 954d37c651029446fea3889a67c0bdf4ff598d31  atheist_0.20100717-1_all.deb
Test-For:
 w: atheist: js-file-referenced-by-search.html-is-compressed usr/share/doc/atheist/html/_static/doctools.js.gz (usr/share/doc/atheist/html/search.html)
 w: atheist: js-file-referenced-by-search.html-is-compressed usr/share/doc/atheist/html/_static/searchtools.js.gz (usr/share/doc/atheist/html/search.html)
 w: atheist: js-file-referenced-by-search.html-is-compressed usr/share/doc/atheist/html/searchindex.js.gz (usr/share/doc/atheist/html/search.html)

Name: rst-source-referenced-by-searchindex.js-does-not-exist
Files:
 f84f1e36bcceb8f22d33b9906be1b6da0cb2495e  python-argparse-doc_1.2.1-2_all.deb
Test-For:
 w: python-argparse-doc: rst-source-referenced-by-searchindex.js-does-not-exist usr/share/doc/python-argparse-doc/html/_sources/argparse.txt (usr/share/doc/python-argparse-doc/html/searchindex.js)
 w: python-argparse-doc: rst-source-referenced-by-searchindex.js-does-not-exist usr/share/doc/python-argparse-doc/html/_sources/license.txt (usr/share/doc/python-argparse-doc/html/searchindex.js)
 w: python-argparse-doc: rst-source-referenced-by-searchindex.js-does-not-exist usr/share/doc/python-argparse-doc/html/_sources/index.txt (usr/share/doc/python-argparse-doc/html/searchindex.js)

Name: rst-source-referenced-by-searchindex.js-is-compressed
Files:
 1b0c799eb914124b57864ca5970917a7b155e8a2  python-cairo-dev_1.8.8-1_all.deb
Test-For:
 w: python-cairo-dev: rst-source-referenced-by-searchindex.js-is-compressed usr/share/doc/python-cairo-dev/html/_sources/reference/patterns.txt.gz (usr/share/doc/python-cairo-dev/html/searchindex.js)
 w: python-cairo-dev: rst-source-referenced-by-searchindex.js-is-compressed usr/share/doc/python-cairo-dev/html/_sources/reference/matrix.txt.gz (usr/share/doc/python-cairo-dev/html/searchindex.js)
 w: python-cairo-dev: rst-source-referenced-by-searchindex.js-is-compressed usr/share/doc/python-cairo-dev/html/_sources/reference/context.txt.gz (usr/share/doc/python-cairo-dev/html/searchindex.js)
 w: python-cairo-dev: rst-source-referenced-by-searchindex.js-is-compressed usr/share/doc/python-cairo-dev/html/_sources/reference/constants.txt.gz (usr/share/doc/python-cairo-dev/html/searchindex.js)
 w: python-cairo-dev: rst-source-referenced-by-searchindex.js-is-compressed usr/share/doc/python-cairo-dev/html/_sources/reference/surfaces.txt.gz (usr/share/doc/python-cairo-dev/html/searchindex.js)
 w: python-cairo-dev: rst-source-referenced-by-searchindex.js-is-compressed usr/share/doc/python-cairo-dev/html/_sources/reference/text.txt.gz (usr/share/doc/python-cairo-dev/html/searchindex.js)

Name: search.html-references-non-local-file/css
Files:
 a4dc325326996c2c5e7405bfe22882d10bc4adfe  python-nipype-doc_0.5.3-2_all.deb
Test-For:
 w: python-nipype-doc: search.html-references-non-local-file usr/share/doc/python-nipype-doc/html/search.html -> http://www.google.com/cse/style/look/default.css

Name: search.html-references-non-local-file/js
Files:
 0012df70983af5e443af746790db3ffc8126df98  pynast_1.1-3_all.deb
Test-For:
 w: pynast: search.html-references-non-local-file usr/share/doc/pynast/html/search.html -> http://www.google.com/jsapi?key=ABQIAAAAdyJBQQABvxRaME0S-wyQoxTmluCkmlcBcOZMfdDozzndIHJ6lxRpv5opdXpr1SRwPuMUtSSFwWiDgw

Name: search.html-references-non-local-file/usr-share-javascript
Files:
 9616848a379558801f98022f741cf092d2345e04  python-sqlkit-doc_0.9.5-1_all.deb
Test-Against:
 w: python-sqlkit-doc: search.html-references-non-local-file usr/share/doc/python-sqlkit-doc/html/search.html -> /usr/share/javascript/jquery/jquery.js
 w: python-sqlkit-doc: search.html-references-non-local-file usr/share/doc/python-sqlkit-doc/html/search.html -> /usr/share/javascript/jquery-ui/jquery-ui.js

Name: search.html-with-invalid-root-url/fragment
Files:
 a0452f86380bf557d6989897a78f3d76ed2875a8  python-sqlparse_0.1.4-1_all.deb
Test-For:
 w: python-sqlparse: search.html-with-invalid-root-url usr/share/doc/python-sqlparse/html/search.html -> #

Name: sphinx-cruft-in-binary-package/1
Files:
 9dfd4e1efc9552dc5c9170872e7db112e289e40a  python-flaskext.wtf_0.6-1_all.deb
Test-For:
 p: python-flaskext.wtf: sphinx-cruft-in-binary-package usr/share/doc/python-flaskext.wtf/html/.buildinfo
 p: python-flaskext.wtf: sphinx-cruft-in-binary-package usr/share/doc/python-flaskext.wtf/html/_static/websupport.js

Name: sphinx-cruft-in-binary-package/2
Files:
 1b0c799eb914124b57864ca5970917a7b155e8a2  python-cairo-dev_1.8.8-1_all.deb
Test-For:
 p: python-cairo-dev: sphinx-cruft-in-binary-package usr/share/doc/python-cairo-dev/html/.buildinfo
 p: python-cairo-dev: sphinx-cruft-in-binary-package usr/share/doc/python-cairo-dev/html/.doctrees/

Name: sphinx-js-incompatible-with-jquery
Files:
 cf01845b4ad64ed44b118bd097c717d9ccfe6dcd  python-argvalidate_0.9.0-1_all.deb
Test-For:
 w: python-argvalidate: sphinx-js-incompatible-with-jquery-1.4 usr/share/doc/python-argvalidate/html/_static/doctools.js
 w: python-argvalidate: sphinx-js-incompatible-with-jquery-1.5 usr/share/doc/python-argvalidate/html/_static/searchtools.js

Name: sphinx-static-file-with-jinja2-templates
Files:
 9616848a379558801f98022f741cf092d2345e04  python-sqlkit-doc_0.9.5-1_all.deb
Test-For:
 w: python-sqlkit-doc: sphinx-static-file-with-jinja2-templates usr/share/doc/python-sqlkit-doc/html/_static/searchtools.js {{ search_language_stemming_code|safe }}
 w: python-sqlkit-doc: sphinx-static-file-with-jinja2-templates usr/share/doc/python-sqlkit-doc/html/_static/default.css {{ theme_bodyfont }}

Name: source-contains-sphinx-cache
Files:
 fe542a678d3fc9c09fe461200bdf78a81c51d5e0  python-pynast_1.1-3.dsc
 69932b10807535084f8c9daed02a928719883361  python-pynast_1.1-3.debian.tar.gz
 ca79b852930c195c9c43d3fc979481301f1b229f  python-pynast_1.1.orig.tar.gz
Test-For:
 w: python-pynast source: source-contains-sphinx-cache doc/_build/doctrees/environment.pickle
 w: python-pynast source: source-contains-sphinx-cache doc/_build/doctrees/index.doctree
 w: python-pynast source: source-contains-sphinx-cache doc/_build/doctrees/install.doctree
 w: python-pynast source: source-contains-sphinx-cache doc/_build/doctrees/install_gui.doctree
