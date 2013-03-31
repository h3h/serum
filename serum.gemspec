Gem::Specification.new do |s|
  s.specification_version = 2 if s.respond_to? :specification_version=
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.rubygems_version = '1.3.5'

  s.name              = 'serum'
  s.version           = '0.2.0'
  s.license           = 'MIT'
  s.date              = '2013-03-30'
  s.rubyforge_project = 'serum'

  s.summary     = "A simple object model on static posts with YAML front matter."
  s.description = "Serum is a simple object model on static posts with YAML front matter."

  s.authors  = ["Brad Fults"]
  s.email    = 'bfults@gmail.com'
  s.homepage = 'http://github.com/h3h/serum'

  s.require_paths = %w[lib]

  s.executables = []

  s.rdoc_options = ["--charset=UTF-8"]
  s.extra_rdoc_files = %w[README.md LICENSE]

  s.add_runtime_dependency('safe_yaml', "~> 0.7.0")

  s.add_development_dependency('rake', "~> 10.0.3")
  s.add_development_dependency('rdoc', "~> 3.11")
  s.add_development_dependency('redgreen', "~> 1.2")
  s.add_development_dependency('shoulda', "~> 3.3.2")
  s.add_development_dependency('rr', "~> 1.0")

  # = MANIFEST =
  s.files = %w[
    Gemfile
    LICENSE
    Rakefile
    lib/serum.rb
    lib/serum/core_ext.rb
    lib/serum/errors.rb
    lib/serum/mime.types
    lib/serum/post.rb
    lib/serum/site.rb
    lib/serum/static_file.rb
    serum.gemspec
    test/helper.rb
    test/source/2008-02-02-not-published.textile
    test/source/2008-02-02-published.textile
    test/source/2008-10-18-foo-bar.textile
    test/source/2008-11-21-complex.textile
    test/source/2008-12-03-permalinked-post.textile
    test/source/2008-12-13-include.markdown
    test/source/2009-01-27-array-categories.textile
    test/source/2009-01-27-categories.textile
    test/source/2009-01-27-category.textile
    test/source/2009-01-27-empty-categories.textile
    test/source/2009-01-27-empty-category.textile
    test/source/2009-03-12-hash-#1.markdown
    test/source/2009-05-18-empty-tag.textile
    test/source/2009-05-18-empty-tags.textile
    test/source/2009-05-18-tag.textile
    test/source/2009-05-18-tags.textile
    test/source/2009-05-24-yaml-linebreak.markdown
    test/source/2009-06-22-empty-yaml.textile
    test/source/2009-06-22-no-yaml.textile
    test/source/2010-01-08-triple-dash.markdown
    test/source/2010-01-09-date-override.textile
    test/source/2010-01-09-time-override.textile
    test/source/2010-01-09-timezone-override.textile
    test/source/2010-01-16-override-data.textile
    test/source/2011-04-12-md-extension.md
    test/source/2011-04-12-text-extension.text
    test/source/2013-01-02-post-excerpt.markdown
    test/source/2013-01-12-nil-layout.textile
    test/source/2013-01-12-no-layout.textile
    test/suite.rb
    test/test_core_ext.rb
    test/test_post.rb
    test/test_site.rb
  ]
  # = MANIFEST =

  s.test_files = s.files.select { |path| path =~ /^test\/test_.*\.rb/ }
end
