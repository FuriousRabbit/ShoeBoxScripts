# Class: autofs
#
# This class wraps *autofs::instalL* for ease of use
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#   include 'autofs'
#   class { 'autofs': }
class autofs {
  include autofs::install, autofs::service
}
