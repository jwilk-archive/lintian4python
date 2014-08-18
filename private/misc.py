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

import os

_here = os.path.dirname(__file__)
root = '{here}/..'.format(here=_here)
architecture = 'i386'
mirror = os.getenv('DEB_MIRROR') or 'http://http.debian.net/debian'

# Local Variables:
# indent-tabs-mode: nil
# End:
# vim: syntax=python sw=4 sts=4 sr et
