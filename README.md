# KindlePras

Commandline Ruby Program to extract highlights of the books I've read from my Kindle.

Inspired from [Derek Siver's Book Notes](https://sivers.org/book).

The extracted, markdown-formatted notes are published as new post in my jekyll site [http://books.npras.in](http://books.npras.in).


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'kindle_pras'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install kindle_pras


## Assumption

The `"My Clippings.txt"` file from the Kindle is placed in the "data" directory.

The file can sometime have unicode character that appears in vim as "<feff>". This char should be removed (substituted with empty string).


## Usage

1. List all books:

```
$ ./bin/kindle_pras -l
```

output will be like:

```
Idx:    2
Book:   A Dirty Job
Author: Moore, Christopher
-------
Idx:    3
Book:   A Guide to the Good Life: The Ancient Art of Stoic Joy
Author: Irvine, William B.
-------
Idx:    4
Book:   A Mind For Numbers: How to Excel at Math and Science (Even If You Flunked Algebra)
Author: Oakley, Barbara
-------
Idx:    5
Book:   A short history of nearly everything
Author: Bill Bryson
-------
Idx:    6
Book:   American Gods
Author: Neil Gaiman
-------
Idx:    7
Book:   As a Man Thinketh
Author: Allen, James
-------
```

2. Extract a specific book's notes and save it as a Jekyll-post:

```
$ ./bin/kindle_pras -e"/long walk/" -n"LongWalk" -r7 -i"9780316548182"
```

Output will be like:

```
Notes extracted and saved in file: 'output/2017-01-28-LongWalk.markdown'
```

* The `-e` flag: is used to specify part of the book's name in regexp format. Use all downcase ("/long walk/"), or use the 'i' flag ("/Long Walk/i").
* The `-n` flag: is used to specify a short name for the book. It's used as part of the filename for the notes file, as well for the url of the jekyll post.
* The `-r` flag: is used to specify the rating (out of 10) for the given book.
* The `-i` flag: is used to specify the ISBN number for the given book. You can find it from [http://www.isbnsearch.org/](http://www.isbnsearch.org/).


Here's how the '-h' help option looks like:

```
./bin/kindle_pras -h
Usage: kindle_pras.rb [options]
    -f, --file=FILE_PATH             path to 'My Clippings.txt' file
    -l, --list                       List all available books
    -eBOOK_TITLE_PART_REGEXP,        Extract all highlights as notes for a given book. Eg: ./bin/kindle_pras -e '/getting things done/' -n 'GTD' -r '7' -i '9781455509126'
        --extract-book
    -n, --name=NAME                  Short name of the book for filename and URL use. Use it along with the '-e', '-i', '-r' flag. Eg: ./bin/kindle_pras -e 'getting things done' -n 'GTD' -r '7' -i '9781455509126'
    -r, --rating=RATING              Rating out of 10 for the book. Use it along with the '-e', 'i' and '-n' flag. Eg: ./bin/kindle_pras -e 'getting things done' -n 'GTD' -r '7' -i '9781455509126'
    -i, --isbn=ISBN                  The book's ISBN. Use http://www.isbnsearch.org/. Use it along with the '-e', '-r' and '-n' flag. Eg: ./bin/kindle_pras -e 'getting things done' -n 'GTD' -r '7' -i '9781455509126'
    -h, --help                       Prints this help
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/kindle_pras.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

