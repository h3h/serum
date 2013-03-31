require 'helper'

class TestPost < Test::Unit::TestCase
  def setup_post(file)
    Post.new(@site, source_dir, '', file)
  end

  context "A Post" do
    setup do
      @site = Site.new(Serum.configuration({'source' => source_dir}))
    end

    should "ensure valid posts are valid" do
      assert Post.valid?("2008-09-09-foo-bar.textile")
      assert Post.valid?("foo/bar/2008-09-09-foo-bar.textile")

      assert !Post.valid?("lol2008-09-09-foo-bar.textile")
      assert !Post.valid?("blah")
    end

    context "processing posts" do
      setup do
        @post = Post.allocate
        @post.site = @site

        @real_file = "2008-10-18-foo-bar.textile"
        @fake_file = "2008-09-09-foo-bar.textile"
        @source = source_dir('')
      end

      should "keep date, title, and markup type" do
        @post.process(@fake_file)

        assert_equal Time.parse("2008-09-09"), @post.date
        assert_equal "foo-bar", @post.slug
        assert_equal ".textile", @post.ext
      end

      should "raise a good error on invalid post date" do
        assert_raise Serum::FatalException do
          @post.process("2009-27-03-foo-bar.textile")
        end
      end

      context "with CRLF linebreaks" do
        setup do
          @real_file = "2009-05-24-yaml-linebreak.markdown"
          @source = source_dir('')
        end
        should "read yaml front-matter" do
          @post.read_yaml(@source, @real_file)

          assert_equal({"title" => "Test title", "layout" => "post", "tag" => "Ruby"}, @post.data)
        end
      end

      context "with embedded triple dash" do
        setup do
          @real_file = "2010-01-08-triple-dash.markdown"
        end
        should "consume the embedded dashes" do
          @post.read_yaml(@source, @real_file)

          assert_equal({"title" => "Foo --- Bar", "layout" => "post"}, @post.data)
        end
      end

      should "read yaml front-matter" do
        @post.read_yaml(@source, @real_file)

        assert_equal({"title" => "Foo Bar", "layout" => "default"}, @post.data)
      end

    end

    context "when in a site" do
      setup do
        @site = Site.new(Serum.configuration({'source' => source_dir}))
        @site.posts = [setup_post('2008-02-02-published.textile'),
                       setup_post('2009-01-27-categories.textile')]
      end

      should "have next post" do
        assert_equal(@site.posts.last, @site.posts.first.next)
      end

      should "have previous post" do
        assert_equal(@site.posts.first, @site.posts.last.previous)
      end

      should "not have previous post if first" do
        assert_equal(nil, @site.posts.first.previous)
      end

      should "not have next post if last" do
        assert_equal(nil, @site.posts.last.next)
      end
    end

    context "initializing posts" do
      should "publish when published yaml is no specified" do
        post = setup_post("2008-02-02-published.textile")
        assert_equal true, post.published
      end

      should "not published when published yaml is false" do
        post = setup_post("2008-02-02-not-published.textile")
        assert_equal false, post.published
      end

      should "recognize date in yaml" do
        post = setup_post("2010-01-09-date-override.textile")
        assert_equal Time, post.date.class
      end

      should "recognize time in yaml" do
        post = setup_post("2010-01-09-time-override.textile")
        assert_equal Time, post.date.class
      end

      should "recognize time with timezone in yaml" do
        post = setup_post("2010-01-09-timezone-override.textile")
        assert_equal Time, post.date.class
      end

      should "allow no yaml" do
        post = setup_post("2009-06-22-no-yaml.textile")
        assert_equal({}, post.data)
      end

      should "allow empty yaml" do
        post = setup_post("2009-06-22-empty-yaml.textile")
        assert_equal({}, post.data)
      end
    end
  end

end
