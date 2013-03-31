require 'helper'

class TestSite < Test::Unit::TestCase
  context "configuring sites" do
    should "expose default baseurl" do
      site = Site.new(Serum::DEFAULTS.merge({'source' => source_dir}))
      assert_equal Serum::DEFAULTS['baseurl'], site.baseurl
    end

    should "expose baseurl passed in from config" do
      site = Site.new(Serum::DEFAULTS.merge({'baseurl' => '/blog', 'source' => source_dir}))
      assert_equal '/blog', site.baseurl
    end
  end
  context "creating sites" do
    setup do
      stub(Serum).configuration do
        Serum::DEFAULTS.merge({'source' => source_dir})
      end
      @site = Site.new(Serum.configuration)
    end

    should "reset data before processing" do
      @site.read_directories
      before_posts = @site.posts.length
      before_static_files = @site.static_files.length
      before_time = @site.time

      @site.read_directories
      assert_equal before_posts, @site.posts.length
      assert_equal before_static_files, @site.static_files.length
      assert before_time <= @site.time
    end

    should "read posts" do
      @site.reset
      @site.read_posts('')
      posts = Dir[source_dir('*')]
      assert_equal posts.size - 1, @site.posts.size
    end

    should "filter entries" do
      ent1 = %w[foo.markdown bar.markdown baz.markdown #baz.markdown#
              .baz.markdow foo.markdown~]
      ent2 = %w[.htaccess _posts _pages bla.bla]

      assert_equal %w[foo.markdown bar.markdown baz.markdown], @site.filter_entries(ent1)
      assert_equal %w[.htaccess bla.bla], @site.filter_entries(ent2)
    end

    should "filter entries with exclude" do
      excludes = %w[README TODO]
      files = %w[index.html site.css .htaccess]

      @site.exclude = excludes + ["exclude*"]
      assert_equal files, @site.filter_entries(excludes + files + ["excludeA"])
    end

    should "not filter entries within include" do
      includes = %w[_index.html .htaccess include*]
      files = %w[index.html _index.html .htaccess includeA]

      @site.include = includes
      assert_equal files, @site.filter_entries(files)
    end

  end
end
