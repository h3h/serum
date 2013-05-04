require 'cgi'

module Serum
  class Post
    include Comparable

    # Valid post name regex.
    MATCHER = %r{
      ^(.+\/)*        # zero or more path segments including their trailing slash
      (\d+-\d+-\d+)   # three numbers (YYYY-mm-dd) separated by hyphens for the date
      -(.*)           # a hyphen followed by the slug
      (\.[^.]+)$      # the file extension after a .
    }x

    # Post name validator. Post filenames must be like:
    # 2008-11-05-my-awesome-post.textile
    #
    # Returns true if valid, false if not.
    def self.valid?(name)
      name =~ MATCHER
    end

    attr_accessor :site
    attr_accessor :data, :content, :output, :ext
    attr_accessor :date, :slug, :published, :dir

    attr_reader :name

    # Initialize this Post instance.
    #
    # site       - The Site.
    # base       - The String path to the dir containing the post file.
    # name       - The String filename of the post file.
    #
    # Returns the new Post.
    def initialize(site, source, dir, name)
      @site = site
      @base = source
      @dir = dir
      @name = name

      self.process(name)
      begin
        self.read_yaml(@base, name)
      rescue Exception => msg
        raise FatalException.new("#{msg} in #{@base}/#{name}")
      end

      # If we've added a date and time to the YAML, use that instead of the
      # filename date. Means we'll sort correctly.
      if self.data.has_key?('date')
        # ensure Time via to_s and reparse
        self.date = Time.parse(self.data["date"].to_s)
      end

      if self.data.has_key?('published') && self.data['published'] == false
        self.published = false
      else
        self.published = true
      end

      if self.data.has_key?('slug')
        self.slug = self.data['slug']
      end
    end

    # Read the YAML frontmatter.
    #
    # base - The String path to the dir containing the file.
    # name - The String filename of the file.
    #
    # Returns nothing.
    def read_yaml(base, name)
      begin
        content = File.read(File.join(base, name))

        if content =~ /\A(---\s*\n.*?\n?)^(---\s*$\n?)/m
          self.data = YAML.safe_load($1)
          self.content = $' # everything after the last match
        end
      rescue => e
        puts "Error reading file #{File.join(base, name)}: #{e.message}"
      rescue SyntaxError => e
        puts "YAML Exception reading #{File.join(base, name)}: #{e.message}"
      end

      self.data ||= {}
    end

    # Compares Post objects. First compares the Post date. If the dates are
    # equal, it compares the Post slugs.
    #
    # other - The other Post we are comparing to.
    #
    # Returns -1, 0, 1
    def <=>(other)
      cmp = self.date <=> other.date
      if 0 == cmp
       cmp = self.slug <=> other.slug
      end
      return cmp
    end

    # Extract information from the post filename.
    #
    # name - The String filename of the post file.
    #
    # Returns nothing.
    def process(name)
      m, cats, date, slug, ext = *name.match(MATCHER)
      self.date = Time.parse(date)
      self.slug = slug
      self.ext = ext
    rescue ArgumentError
      raise FatalException.new("Post #{name} does not have a valid date.")
    end

    # The full path and filename of the post. Defined in the YAML of the post
    # body (optional).
    #
    # Returns the String permalink.
    def permalink
      self.data && self.data['permalink']
    end

    # The generated relative url of this post.
    # e.g. /2008/11/05/my-awesome-post.html
    #
    # Returns the String URL.
    def url
      return @url if @url

      url = "#{self.site.baseurl}#{self.id}"

      # sanitize url
      @url = url.split('/').reject{ |part| part =~ /^\.+$/ }.join('/')
      @url += "/" if url =~ /\/$/
      @url
    end

    # The UID for this post (useful in feeds).
    # e.g. /2008/11/05/my-awesome-post
    #
    # Returns the String UID.
    def id
      File.join(self.dir, self.slug)
    end

    # Returns the shorthand String identifier of this Post.
    def inspect
      "<Post: #{self.id}>"
    end

    def next
      pos = self.site.posts.index(self)

      if pos && pos < self.site.posts.length-1
        self.site.posts[pos+1]
      else
        nil
      end
    end

    def previous
      pos = self.site.posts.index(self)
      if pos && pos > 0
        self.site.posts[pos-1]
      else
        nil
      end
    end

    def method_missing(meth, *args)
      if self.data.has_key?(meth.to_s) && args.empty?
        self.data[meth.to_s]
      else
        super
      end
    end

  end
end
