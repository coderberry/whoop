# Whoop

[![Gem Version](https://badge.fury.io/rb/whoop.svg)](https://badge.fury.io/rb/whoop)
[![Maintainability](https://api.codeclimate.com/v1/badges/1ffd27fe59383a4ff52b/maintainability)](https://codeclimate.com/github/coderberry/whoop/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/1ffd27fe59383a4ff52b/test_coverage)](https://codeclimate.com/github/coderberry/whoop/test_coverage)
[![Tests](https://github.com/coderberry/whoop/actions/workflows/tests.yml/badge.svg)](https://github.com/coderberry/whoop/actions/workflows/tests.yml)
[![CodeQL](https://github.com/coderberry/whoop/actions/workflows/codeql-analysis.yml/badge.svg)](https://github.com/coderberry/whoop/actions/workflows/codeql-analysis.yml)
[![StandardRB](https://github.com/coderberry/whoop/actions/workflows/standardrb.yml/badge.svg)](https://github.com/coderberry/whoop/actions/workflows/standardrb.yml)
[![GEM Version](https://img.shields.io/gem/v/whoop?color=168AFE&include_prereleases&logo=ruby&logoColor=FE1616)](https://rubygems.org/gems/whoop)
[![GEM Downloads](https://img.shields.io/gem/dt/whoop?color=168AFE&logo=ruby&logoColor=FE1616)](https://rubygems.org/gems/whoop)
[![Ruby Style](https://img.shields.io/badge/style-standard-168AFE?logo=ruby&logoColor=FE1616)](https://github.com/testdouble/standard)
[![Twitter Follow](https://img.shields.io/twitter/follow/coderberry?logo=twitter&style=social)](https://twitter.com/coderberry)

Whoop is a Ruby logging library that makes it easy to find and analyze your *debugging* logs.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add whoop

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install whoop

## Usage

```ruby
require 'whoop'

w("Hello, World!")
# => "Hello, World!"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/whoop. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/whoop/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Whoop project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/whoop/blob/main/CODE_OF_CONDUCT.md).

## Attribution

This project is maintained by [Eric Berry](https://linktr.ee/coderberry).

This gem is based on the [wrapped_print](https://github.com/igorkasyanchuk/wrapped_print) gem by [Igor Kasyanchuk](https://www.railsjazz.com/).
