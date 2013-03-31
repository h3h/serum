require 'rubygems'
require 'test/unit'

require 'serum'

require 'redgreen' if RUBY_VERSION < '1.9'
require 'shoulda'
require 'rr'

include Serum

# Send STDERR into the void to suppress program output messages
STDERR.reopen(test(?e, '/dev/null') ? '/dev/null' : 'NUL:')

class Test::Unit::TestCase
  include RR::Adapters::TestUnit

  def source_dir(*subdirs)
    test_dir('source', *subdirs)
  end

  def test_dir(*subdirs)
    File.join(File.dirname(__FILE__), *subdirs)
  end

end
