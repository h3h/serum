# Serum

Serum is a simple object model on static posts with [YAML front matter](http://jekyllrb.com/docs/frontmatter/), like [Jekyll](http://jekyllrb.com/).

## Usage

Instantiate Serum passing in a directory of files that may or may not have
YAML front matter:

```irb
>> site = Serum.for_dir("posts/")
=> <Site: /Users/bob/posts>
```

Then ask questions about the posts:

```irb
>> site.posts.size
=> 28

>> site.posts.first
=> <Post: /published>

>> site.posts.first.next
=> <Post: /foo-bar>
```

You can also pass in a `'baseurl'` option to `for_dir` in order to get URL
generation on each of the posts:

```irb
>> site = Serum.for_dir('posts/', {'baseurl' => '/story'})
=> <Site: /Users/bob/posts>

>> site.posts.first.url
=> "/story/published"
```

It's really that simple. Sometimes you just want a Ruby object model on top of
a simple directory of posts.

## Author

Maybe more aptly named "deleter" considering this project's origin.

[Brad Fults](http://github.com/h3h) ([bfults@gmail.com](mailto:bfults@gmail.com))

## Acknowledgements

Serum is based entirely on [Jekyll](http://jekyllrb.com/) from Tom Preston-Werner.
Thank you, Tom.

## License

MIT License; see `LICENSE` file.
