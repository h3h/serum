$:.unshift File.dirname(__FILE__) # For use/testing when no gem is installed

# Require all of the Ruby files in the given directory.
#
# path - The String relative path from here to the directory.
#
# Returns nothing.
def require_all(path)
  glob = File.join(File.dirname(__FILE__), path, '*.rb')
  Dir[glob].each do |f|
    require f
  end
end

# rubygems
require 'rubygems'

# stdlib
require 'fileutils'
require 'time'
require 'safe_yaml'
require 'English'

# internal requires
require 'serum/core_ext'
require 'serum/site'
require 'serum/post'
require 'serum/static_file'
require 'serum/errors'

SafeYAML::OPTIONS[:suppress_warnings] = true

module Serum
  VERSION = '0.2.0'

  # Default options.
  # Strings rather than symbols are used for compatability with YAML.
  DEFAULTS = {
    'source'        => Dir.pwd,
    'permalink'     => ':title',
    'baseurl'       => '',
    'include'       => ['.htaccess'],
  }

  # Public: Generate a Serum configuration Hash by merging the default
  # options with anything in _config.yml, and adding the given options on top.
  #
  # override - A Hash of config directives that override any options in both
  #            the defaults and the config file. See Serum::DEFAULTS for a
  #            list of option names and their defaults.
  #
  # Returns the final configuration Hash.
  def self.configuration(override)
    # Convert any symbol keys to strings and remove the old key/values
    override = override.reduce({}) { |hsh,(k,v)| hsh.merge(k.to_s => v) }

    # Merge DEFAULTS < override
    Serum::DEFAULTS.deep_merge(override)
  end

  # Public: Generate a new Serum::Site for the given directory.
  #
  # source - A String path to the directory.
  # opts   - A Hash of additional configuration options.
  #
  # Returns the Serum::Site.
  def self.for_dir(source, opts={})
    Serum::Site.new(configuration({source: source}.merge(opts)))
  end

end
