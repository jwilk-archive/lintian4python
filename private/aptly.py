# Copyright © 2012, 2013, 2014 Jakub Wilk
#
# This program is free software.  It is distributed under the terms of the GNU
# General Public License as published by the Free Software Foundation; either
# version 2 of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
# more details.
#
# You should have received a copy of the GNU General Public License along with
# this program.  If not, you can find it on the World Wide Web at
# https://www.gnu.org/copyleft/gpl.html, or write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA.

import sys

import apt
import apt_inst
import apt_pkg

class AcquireProgress(apt.progress.text.AcquireProgress):
    def __init__(self):
        apt.progress.text.AcquireProgress.__init__(self, outfile=sys.stderr)

class AcquireFailed(RuntimeError):
    pass

class Acquire(apt_pkg.Acquire):

    def run(self):
        rc = apt_pkg.Acquire.run(self)
        if rc != self.RESULT_CONTINUE:
            raise AcquireFailed('fetching files failed')
        for file in self.items:
            if file.status != file.STAT_DONE:
                raise AcquireFailed('fetching file failed: {uri}'.format(uri=file.desc_uri))

AcquireFile = apt_pkg.AcquireFile

TagFile = apt_pkg.TagFile

DebFile = apt_inst.DebFile

# Local Variables:
# indent-tabs-mode: nil
# End:
# vim: syntax=python sw=4 sts=4 sr et
