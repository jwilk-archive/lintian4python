Name: debian-pycompat-is-obsolete
Files:
 4e3a1377cc8fc868a6a0e53c84496f1a999f18be  apt-forktracer_0.4.dsc
 6b1e175b5a6cd21a4ddab27704715a6740e16bba  apt-forktracer_0.4.tar.gz
Test-For:
 i: apt-forktracer source: debian-pycompat-is-obsolete

Name: insufficient-build-dependency-on-python-helper
Files:
 927e3889feda6da0ddebabd902819dfdee7eb7d0  markupsafe_0.15-1.debian.tar.gz
 a4328c89611b5896771653526d43a44204a2983a  markupsafe_0.15-1.dsc
 81e0c898c289721d5b1aa70ffc0dfc35886ea92a  markupsafe_0.15.orig.tar.gz
Test-For:
 p: markupsafe source: insufficient-build-dependency-on-python-helper dh_python2 => python (>= 2.6.6-3~)

Name: insufficient-build-dependency-on-python-helper/pyinstall
Files:
 20bec191acde70fdb5f445f2e6a09058241fecf4  flufl.enum_3.3.2-1.dsc
 b2943b038f585e31437baff8ab9af80fd44224a1  flufl.enum_3.3.2-1.debian.tar.gz
 6c60f4bafd56b263d9a3cd577aca3e7abe78abe3  flufl.enum_3.3.2.orig.tar.gz
Test-For:
 p: flufl.enum source: insufficient-build-dependency-on-python-helper dh_python2 .pyinstall/.pyremove support => python (>= 2.6.6-6~)

Name: insufficient-build-dependency-on-python-helper/option
Files:
 5a2de8a7704b93686122be47b3f6a55f554c2411  radare2-bindings_0.9-1.dsc
 b4fd0682984db34f42a5e13aefdf1946cde0f729  radare2-bindings_0.9-1.debian.tar.gz
 81bf941e2fd687e2d3cabc67fe797314177c89c9  radare2-bindings_0.9.orig.tar.gz
Test-For:
 p: radare2-bindings source: insufficient-build-dependency-on-python-helper dh_python2 --namespace => python (>= 2.6.6-14~)

Name: insufficient-build-dependency-on-python-helper/ok
Files:
 96700ab6bd6f9e8b026f7accfbb615d1b1dd0879  flask-wtf_0.6-1.dsc
 fa9c08633785accdc9359cecd1cc47027bdf6bfe  flask-wtf_0.6-1.diff.gz
 4fcbe0975847cbed9bef3e9d5db75079807915a7  flask-wtf_0.6.orig.tar.gz
Test-Against:
 e: flask.wtf source: insufficient-build-dependency-on-python-helper ...
 e: flask.wtf source: missing-versioned-build-dependency-on-python-helper ...

Name: invalid-python-version-declaration/lt-only
Files:
 ed411857e8471ea984a91df76965bb96983d7350  codespeak-lib_1.4.8-1.dsc
 0d5cfa0c7c19081cdc4c564558247fb781262b63  codespeak-lib_1.4.8-1.debian.tar.gz
 afb1af1ee31d0c927b9e2870e67dfada21d4e7aa  codespeak-lib_1.4.8.orig.tar.bz2
Test-For:
 e: codespeak-lib source: invalid-python-version-declaration X-Python3-Version: << 3.3

Name: invalid-python-version-declaration/version-list
Files:
 8377b7f49411ad46c6915c83cd1b286077b56ef7  python-pam_0.4.2-13.dsc
 0bff30c4001cd752eaa7a3d3df33e3c71b83213f  python-pam_0.4.2-13.diff.gz
 5327b027cd74d84bd6f0147245f02477d46d3c33  python-pam_0.4.2.orig.tar.gz
Test-For:
 e: python-pam source: invalid-python-version-declaration X-Python-Version: 2.6, 2.7

Name: invalid-python-version-declaration/3.0
Files:
 2eba4405f593c21befdb681816bd0ce62ce27d45  python-pipeline_0.1.3-3.dsc
 ce6e424326b20dbadaad434ca1aa9dbdf48e5b4d  python-pipeline_0.1.3-3.debian.tar.gz
 3f68107ec180de958ce7debc165e45cdbe870edd  python-pipeline_0.1.3.orig-py3k.tar.gz
 4c476d0abe61a1466ecece8e1bb211a71d59d688  python-pipeline_0.1.3.orig.tar.gz
Test-Against:
 e: python-pipeline source: invalid-python-version-declaration X-Python3-Version: >= 3.0

Name: python-module-but-no-python-depends/development-packages
Files:
 7bb698c875bb8ec3ae92fe81571bc5f1f88ec929  python-greenlet_0.3.3-1.dsc
 e90a8d447b84c1176c31ab66e2d45bbee5fd2ca4  python-greenlet_0.3.3-1.debian.tar.gz
 96548b70b96db654082709c2f5fdfede065c2dc9  python-greenlet_0.3.3.orig.tar.gz
Test-Against:
 e: python-greenlet source: python-module-but-no-python-depends python-greenlet-dev
 e: python-greenlet source: python-module-but-no-python-depends python-greenlet-dbg
Info:
 Fixed in lintian4python 0.4.  This was initially implemented correctly, but
 regressed in lintian4python 0.2.

Name: python-module-but-no-python-depends/metapackages
Files:
 bef9649f655519229934d014a1dc035988e60096  sphinx-issuetracker_0.8-1.dsc
 40b0c13ecfdefe6ed7011de14fb378b190395267  sphinx-issuetracker_0.8-1.debian.tar.gz
 d4f4dc56ce75102f1cfbc5f6e7c0894d3481e60b  sphinx-issuetracker_0.8.orig.tar.gz
Test-Against:
 e: sphinx-issuetracker source: python-module-but-no-python-depends python-sphinx-issuetracker
Info:
 Fixed in lintian4python 0.4.  This was initially implemented correctly, but
 regressed in lintian4python 0.2.

Name: hardcoded-dependency-on-python-helper/python-support
Files:
 0689696f94ce72c3ed6f0af7666b626c286f7c81  django-classy-tags_0.3.4.1-1.dsc
 fe666471bc2c39c487ddaf7cb6b1840812d38e20  django-classy-tags_0.3.4.1-1.debian.tar.gz
 d3fc074446a99bc1a16a84524bc8567d36ced579  django-classy-tags_0.3.4.1.orig.tar.gz
Test-For:
 e: django-classy-tags source: python-module-but-no-python-depends python-django-classy-tags
 e: django-classy-tags source: hardcoded-dependency-on-python-helper python-support

Name: python-stdeb-boilerplate/rules
Files:
 014ed17e9b40e42ecd969685cf57531303436fa6  cpuset_1.5.6-2.dsc
 f66075f0554312d073c89ef86b38601b19361124  cpuset_1.5.6-2.debian.tar.gz
 c0bbb0272e18187c3249162dc36b1fa5ef2daf7e  cpuset_1.5.6.orig.tar.gz
Test-For:
 i: cpuset source: python-stdeb-boilerplate debian/rules:3 "This file was automatically generated by stdeb 0.6.0"

Name: python-stdeb-boilerplate/changelog
Files:
 60aa4263bc9a7a61a96000c1565e278956f2f8fd  python-quantities_0.10.1-1_all.deb
Test-For:
 i: python-quantities: python-stdeb-boilerplate changelog:3 "source package automatically created by stdeb 0.6.0+git"

Name: x-python-version-instead-of-xs-python-version
Files:
 cac1c4f1ba906ea13d3a4c047dc9bd2ebd25dd69  purity-ng_0.2.0-2.dsc
 c61e69904628489c134279b4e7903f918bc41f61  purity-ng_0.2.0-2.debian.tar.gz
 0adf06e643d666ee8fbdbd1216bde71bfc2a6ee0  purity-ng_0.2.0.orig.tar.gz
Test-For:
 e: purity-ng source: x-python-version-instead-of-xs-python-version

Name: xs-python-version-instead-of-x-python-version
Files:
 a4328c89611b5896771653526d43a44204a2983a  markupsafe_0.15-1.dsc
 927e3889feda6da0ddebabd902819dfdee7eb7d0  markupsafe_0.15-1.debian.tar.gz
 81e0c898c289721d5b1aa70ffc0dfc35886ea92a  markupsafe_0.15.orig.tar.gz
Test-For:
 w: markupsafe source: xs-python-version-instead-of-x-python-version

Name: xs-python3-version-instead-of-x-python3-version
Files:
 3ee3507baf6578d8bd5b97ed7e1c1847c5a955ce  python-iowait_0.1-1.1.dsc
 dd00a15fb343612cdb931e09c3b96febb57a14aa  python-iowait_0.1-1.1.debian.tar.gz
 9482a363e8fedd6f08ded2c098ac330068535711  python-iowait_0.1.orig.tar.gz
Test-For:
 e: python-iowait source: xs-python3-version-instead-of-x-python3-version

Name: multiple-python-version-declarations/xspv+xpv
Files:
 2f269aa0cc2b72fec1b22061e944db836fe6c253  xdelta3_3.0.0.dfsg-1.dsc
 89d611f2e8b467b5cb5038d15a7be4df2401acd4  xdelta3_3.0.0.dfsg-1.debian.tar.gz
 ca8ffc1a74f5808411d3abb3f83bb1f978725295  xdelta3_3.0.0.dfsg.orig.tar.bz2
Test-For:
 e: xdelta3 source: multiple-python-version-declarations XS-Python-Version X-Python-Version

Name: multiple-python-version-declarations/xspv+pyversions
Files:
 a51a69d859815745f8495474a89012c6ecaeb6a7  python-lzma_0.5.3-2.dsc
 5a663fae58d782d5b2c08574e57c4cad070c09da  python-lzma_0.5.3-2.debian.tar.gz
 6240ec6f830f35f4087b8926a95c2074320b7ed5  python-lzma_0.5.3.orig.tar.bz2
Test-For:
 e: python-lzma source: multiple-python-version-declarations XS-Python-Version debian/pyversions

Name: xs-python-version-current-is-deprecated
Files:
 014ed17e9b40e42ecd969685cf57531303436fa6  cpuset_1.5.6-2.dsc
 f66075f0554312d073c89ef86b38601b19361124  cpuset_1.5.6-2.debian.tar.gz
 c0bbb0272e18187c3249162dc36b1fa5ef2daf7e  cpuset_1.5.6.orig.tar.gz
Test-For:
 w: cpuset source: xs-python-version-current-is-deprecated

Name: substitution-variable-in-xs-python-version
Files:
 2cac0544500b7f2b4de0748aebb7e41f93345639  colortest-python_1.4-1.dsc
 ee316f4cd7e8a692335f64c4f40374ae3df6b1ec  colortest-python_1.4-1.debian.tar.gz
 263292bb48b5cac2c558efd70f1728f08d05eab4  colortest-python_1.4.orig.tar.gz
Test-For:
 e: colortest-python source: substitution-variable-in-xs-python-version ${python:Versions}

Name: python-provides-considered-harmful
Files:
 3092bfef396ba31cced54610bda1df4492b5cf56  python-minimock_1.2.6-2.dsc
 87a732907491325838e59bd7cf726caf105162dd  python-minimock_1.2.6-2.debian.tar.gz
 dc7d647c947302bffae46fee6e1b7685bddbe7d0  python-minimock_1.2.6.orig.tar.gz
Test-For:
 i: python-minimock source: python-provides-considered-harmful python-minimock

Name: python-breaks-is-obsolete
Files:
 3092bfef396ba31cced54610bda1df4492b5cf56  python-minimock_1.2.6-2.dsc
 87a732907491325838e59bd7cf726caf105162dd  python-minimock_1.2.6-2.debian.tar.gz
 dc7d647c947302bffae46fee6e1b7685bddbe7d0  python-minimock_1.2.6.orig.tar.gz
Test-For:
 i: python-minimock source: python-breaks-is-obsolete python-minimock

Name: xb-python-version-is-deprecated/binary
Files:
 c951f8198160c8c096130fc5574d2df8ce7cf5a4  flashbake_0.26.2-4_all.deb
Test-For:
 w: flashbake: xb-python-version-is-deprecated

Name: xb-python-version-is-deprecated/source
Files:
 014ed17e9b40e42ecd969685cf57531303436fa6  cpuset_1.5.6-2.dsc
 f66075f0554312d073c89ef86b38601b19361124  cpuset_1.5.6-2.debian.tar.gz
 c0bbb0272e18187c3249162dc36b1fa5ef2daf7e  cpuset_1.5.6.orig.tar.gz
Test-For:
 w: cpuset source: xb-python-version-is-deprecated cpuset

Name: unneeded-pycentral-pkgremove-in-preinst
Files:
 ee723e9a3d7c8f54eb8883827ba3221fe6836bb0  cpuset_1.5.6-2_all.deb
Test-For:
 w: cpuset: unneeded-pycentral-pkgremove-in-preinst
