Name: dbg-extension-in-non-dbg-package
Files:
 da242a92cc8d33389aba205519b22474f4a0f9e2  python-gevent_0.13.7-1_i386.deb
Test-For:
 e: python-gevent: dbg-extension-in-non-dbg-package usr/lib/python2.6/dist-packages/gevent/core_d.so
 e: python-gevent: dbg-extension-in-non-dbg-package usr/lib/python2.7/dist-packages/gevent/core_d.so

Name: extension-compiled-for-wrong-version
Files:
 254fe536c56593f5effd46c95ec2dfdf4e55d2d0  python-semanage_2.1.6-2_i386.deb
Test-For:
 e: python-semanage: extension-compiled-for-wrong-version 2.6 usr/lib/python-support/python-semanage/python2.7/_semanage.so
Info: https://bugs.debian.org/665803

Name: extension-linked-with-libpython
Files:
 32fc3d93837bcf15d08377ee70a0b8f6edd47794  python-nflog_0.1-2_i386.deb
Test-For:
 i: python-nflog: extension-linked-with-libpython usr/lib/python2.6/dist-packages/_nflog.so
 i: python-nflog: extension-linked-with-libpython usr/lib/python2.7/dist-packages/_nflog.so

Name: extension-uses-old-pyrex-import-type
Files:
 170c4a2a8beaf88b781c4fb0fde317d607bd51b8  python-netcdf_2.8-3+b2_i386.deb
Test-For:
 e: python-netcdf: extension-uses-old-pyrex-import-type usr/lib/python2.6/dist-packages/Scientific/linux2/Scientific_affinitypropagation.so
 e: python-netcdf: extension-uses-old-pyrex-import-type usr/lib/python2.6/dist-packages/Scientific/linux2/Scientific_interpolation.so
 e: python-netcdf: extension-uses-old-pyrex-import-type usr/lib/python2.7/dist-packages/Scientific/linux2/Scientific_affinitypropagation.so
 e: python-netcdf: extension-uses-old-pyrex-import-type usr/lib/python2.7/dist-packages/Scientific/linux2/Scientific_interpolation.so

Name: extension-with-soname
Files:
 32fc3d93837bcf15d08377ee70a0b8f6edd47794  python-nflog_0.1-2_i386.deb
Test-For:
 p: python-nflog: extension-with-soname usr/lib/python2.6/dist-packages/_nflog.so (_nflog.so)
 p: python-nflog: extension-with-soname usr/lib/python2.7/dist-packages/_nflog.so (_nflog.so)

Name: python3-extension-without-abi-tag
Files:
 d1ab0a819dac9f9df7d2a698595cd06d0180d7ed  python-hivex_1.3.5-2_i386.deb
Test-For:
 e: python-hivex: python3-extension-without-abi-tag usr/lib/python3/dist-packages/libhivexmod.so

Name: static-extension
Files:
 36d10fac24152008a33b2e2ee2a0d5200c6ff565  python-magics++_2.14.11-3_i386.deb
Test-For:
 w: python-magics++: static-extension usr/lib/python2.6/dist-packages/Magics/_Magics.a
 w: python-magics++: static-extension usr/lib/python2.7/dist-packages/Magics/_Magics.a

Name: extension-is-symlink
Files:
 4fe3dddd83e4e1afa25972be07a2a275cbc24059  python-pypoker-eval_138.0-1+b1_i386.deb
Test-For:
 i: python-pypoker-eval: extension-is-symlink usr/lib/python2.6/dist-packages/_pokereval_2_6.so -> _pokereval_2_6.so.1.0.0
