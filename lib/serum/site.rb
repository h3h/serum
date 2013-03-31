module Serum
  class Site
    attr_accessor :config, :posts, :static_files, :exclude, :include, :source
    attr_accessor :time, :baseurl

    # Public: Initialize a new Site.
    #
    # config - A Hash containing site configuration details.
    def initialize(config)
      self.config          = config.clone

      self.source          = File.expand_path(config['source'])
      self.baseurl         = config['baseurl']
      self.exclude         = config['exclude'] || []
      self.include         = config['include'] || []

      self.reset
      self.read_directories
    end

    # Reset Site details.
    #
    # Returns nothing
    def reset
      self.time            = if self.config['time']
                               Time.parse(self.config['time'].to_s)
                             else
                               Time.now
                             end
      self.posts           = []
      self.static_files    = []
    end

    # Recursively traverse directories to find posts and static files
    # that will become part of the site according to the rules in
    # filter_entries.
    #
    # dir - The String relative path of the directory to read. Default: ''.
    #
    # Returns nothing.
    def read_directories(dir = '')
      self.reset
      base = File.join(self.source, dir)
      entries = Dir.chdir(base) { filter_entries(Dir.entries('.')) }

      self.read_posts(dir)
      self.posts.sort!

      entries.each do |f|
        f_abs = File.join(base, f)
        f_rel = File.join(dir, f)
        if File.directory?(f_abs)
          read_directories(f_rel)
        elsif !File.symlink?(f_abs)
          static_files << StaticFile.new(self, self.source, dir, f)
        end
      end
    end

    # Read all the files in <source>/<dir> and create a new Post
    # object with each one.
    #
    # dir - The String relative path of the directory to read.
    #
    # Returns nothing.
    def read_posts(dir)
      entries = get_entries(dir, '')

      # first pass processes, but does not yet render post content
      entries.each do |f|
        if Post.valid?(f)
          post = Post.new(self, self.source, dir, f)

          if post.published && post.date <= self.time
            self.posts << post
          end
        end
      end
    end

    # Filter out any files/directories that are hidden or backup files (start
    # with "." or "#" or end with "~"), or contain site content (start with "_"),
    # or are excluded in the site configuration, unless they are web server
    # files such as '.htaccess'.
    #
    # entries - The Array of String file/directory entries to filter.
    #
    # Returns the Array of filtered entries.
    def filter_entries(entries)
      entries.reject do |e|
        unless self.include.glob_include?(e)
          ['.', '_', '#'].include?(e[0..0]) ||
          e[-1..-1] == '~' ||
          self.exclude.glob_include?(e) ||
          (File.symlink?(e) && self.safe)
        end
      end
    end

    # Read the entries from a particular directory for processing
    #
    # dir - The String relative path of the directory to read
    # subfolder - The String directory to read
    #
    # Returns the list of entries to process
    def get_entries(dir, subfolder)
      base = File.join(self.source, dir, subfolder)
      return [] unless File.exists?(base)
      entries = Dir.chdir(base) { filter_entries(Dir['**/*']) }
    end

    def inspect
      "<Site: #{source}>"
    end
  end
end
