# Whoop

[![Gem Version](https://badge.fury.io/rb/whoop.svg)](https://badge.fury.io/rb/whoop)
[![Contribute](https://img.shields.io/badge/Contribute%20with-Gitpod-908a85?logo=gitpod)](https://gitpod.io/#https://github.com/coderberry/whoop)
[![Maintainability](https://api.codeclimate.com/v1/badges/1ffd27fe59383a4ff52b/maintainability)](https://codeclimate.com/github/coderberry/whoop/maintainability)
[![codecov](https://codecov.io/gh/coderberry/whoop/branch/main/graph/badge.svg?token=E906B6SEKD)](https://codecov.io/gh/coderberry/whoop)
[![Tests](https://github.com/coderberry/whoop/actions/workflows/tests.yml/badge.svg)](https://github.com/coderberry/whoop/actions/workflows/tests.yml)
[![CodeQL](https://github.com/coderberry/whoop/actions/workflows/codeql-analysis.yml/badge.svg)](https://github.com/coderberry/whoop/actions/workflows/codeql-analysis.yml)
[![StandardRB](https://github.com/coderberry/whoop/actions/workflows/standardrb.yml/badge.svg)](https://github.com/coderberry/whoop/actions/workflows/standardrb.yml)
[![GEM Version](https://img.shields.io/gem/v/whoop?color=168AFE&include_prereleases&logo=ruby&logoColor=FE1616)](https://rubygems.org/gems/whoop)
[![GEM Downloads](https://img.shields.io/gem/dt/whoop?color=168AFE&logo=ruby&logoColor=FE1616)](https://rubygems.org/gems/whoop)
[![Ruby Style](https://img.shields.io/badge/style-standard-168AFE?logo=ruby&logoColor=FE1616)](https://github.com/testdouble/standard)
[![Twitter Follow](https://img.shields.io/twitter/follow/coderberry?logo=twitter&style=social)](https://twitter.com/coderberry)

Whoop is a Ruby logging library with built-in formatting and colorization.

To try **whoop** within your browser, visit the [whoop playground](https://replit.com/@coderberry/whoop-playground).

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add whoop

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install whoop

## Configuration

You can configure the gem for you Rails app by adding an an initializer:

```ruby
# config/initializers/whoop.rb
Whoop.setup do |config|
  config.logger = ActiveSupport::Logger.new("log/debug.log")
  # config.logger = ActiveSupport::Logger.new("log/#{Rails.env}.log")
  # config.logger = ActiveSupport::Logger.new($stdout)
  # config.logger = SemanticLogger["WHOOP"]
  # config.logger = nil # uses `puts`

  config.level = :debug
  # config.level = :info
  # config.level = :warn
  # config.level = :error
end
```

## Usage

The `whoop` method is accessible from any object. See specs for more examples.

```ruby
whoop "Hello, World!"
```

You can pass any options into the `whoop` method to change the output.

- `label` (first argument) - Either the object or title if a block is passed (see below)
- `pattern` - String character to use for the line (default is `-`)
- `count` - the number of times to repeat the pattern per line (e.g. 80)
- `color` - the color to use for the line (e.g. :red)
- `format` - the format to use for the message (one of `:json`, `:sql`, `:plain`, `:pretty`)
- `caller_depth` - the depth of the caller to use for the source (default: 0)
- `explain` - whether to run `EXPLAIN` on the SQL query (default: false)
- `context` - a hash of key/value pairs to include in the output
- `tags` - an array of tags to include in the output

## Examples

```ruby
whoop "Hello"

# log/debug.log
# ┏--------------------------------------------------------------------------------
# ┆ timestamp: 2022-09-26 14:28:06 -0600
# ┆ source: /spec/whoop_spec.rb:12
#
# Hello
# 
# ┗--------------------------------------------------------------------------------
```

```ruby
whoop("My Label", color: :green) { "Hello" }

# log/debug.log (the colors don't appear in markdown)
# ┏------------------------------------ My Label ------------------------------------
# ┆ timestamp: 2022-09-26 14:28:06 -0600
# ┆ source: /spec/whoop_spec.rb:26
#
# Hello
# 
# ┗--------------------------------------------------------------------------------
```

```ruby
whoop({hello: "world"}, format: :json, color: false)

# ┏--------------------------------------------------------------------------------
# ┆ timestamp: 2022-09-26 14:28:06 -0600
# ┆ source: /spec/whoop_spec.rb:39
#
# {
#   "hello": "world"
# }
# 
# ┗--------------------------------------------------------------------------------
```

```ruby
user = User.first # or some object
whoop(user, format: :pretty)

# ┏--------------------------------------------------------------------------------
# ┆ timestamp: 2022-09-26 14:28:06 -0600
# ┆ source: /spec/whoop_spec.rb:39
#
# User {
#         :id => 1,
#       :name => "Eric",
#   :location => "Utah"
# }
# 
# ┗--------------------------------------------------------------------------------
```

```ruby
whoop("This message includes context", color: false, context: {user: "Eric", ip_address: "127.0.0.1"})

# ┏--------------------------------------------------------------------------------
# ┆ timestamp: 2022-09-26 14:28:06 -0600
# ┆ source: /spec/whoop_spec.rb:39
# ┆ user: Eric
# ┆ ip_address: 127.0.0.1
#
# This message includes context
# 
# ┗--------------------------------------------------------------------------------
```

```ruby
sql = 'SELECT emp_id, first_name,last_name,dept_id,mgr_id, ' +
      'WIDTH_BUCKET(department_id,20,40,10) "Exists in Dept" ' +
      'FROM emp WHERE mgr_id < 300 ORDER BY "Exists in Dept"'

whoop(sql, format: :sql)

# ┏--------------------------------------------------------------------------------
# ┆ timestamp: 2022-09-26 14:28:06 -0600
# ┆ source: /spec/whoop_spec.rb:52
#
# SELECT
#     emp_id
#     ,first_name
#     ,last_name
#     ,dept_id
#     ,mgr_id
#     ,WIDTH_BUCKET (
#       department_id
#       ,20
#       ,40
#       ,10
#     ) "Exists in Dept"
#   FROM
#     emp
#   WHERE
#     mgr_id < 300
#   ORDER BY
#     "Exists in Dept"
# 
# ┗--------------------------------------------------------------------------------
```

#### Auto-explain SQL queries

In addition to formatting the SQL query, you can also ask whoop to perform an
`explain` on the query by using the `explain: true` argument.

Example (using the Example 1 sample plan from explain.dalibo.com):

```ruby
sql = <<~SQL
    SELECT rel_users_exams.user_username AS rel_users_exams_user_username,
             rel_users_exams.exam_id AS rel_users_exams_exam_id,
             rel_users_exams.started_at AS rel_users_exams_started_at,
             rel_users_exams.finished_at AS rel_users_exams_finished_at,
             exam_1.id AS exam_1_id,
             exam_1.title AS exam_1_title,
             exam_1.date_from AS exam_1_date_from,
             exam_1.date_to AS exam_1_date_to,
             exam_1.created AS exam_1_created,
             exam_1.created_by_ AS exam_1_created_by_,
             exam_1.duration AS exam_1_duration,
             exam_1.success_threshold AS exam_1_success_threshold,
             exam_1.published AS exam_1_published
    FROM rel_users_exams LEFT OUTER
    JOIN exam AS exam_1
        ON exam_1.id = rel_users_exams.exam_id
    WHERE 1 = rel_users_exams.exam_id;
SQL

whoop("SQL with Explain", format: :sql, explain: true) { sql }

# ┏-------------------------------- SQL with Explain --------------------------------
# ┆ timestamp: 2022-09-26 14:50:11 -0600
# ┆ source: (irb):23:in `<top (required)>'
#
# sql:
#
# SELECT
#     rel_users_exams.user_username AS rel_users_exams_user_username
#     ,rel_users_exams.exam_id AS rel_users_exams_exam_id
#     ,rel_users_exams.started_at AS rel_users_exams_started_at
#     ,rel_users_exams.finished_at AS rel_users_exams_finished_at
#     ,exam_1.id AS exam_1_id
#     ,exam_1.title AS exam_1_title
#     ,exam_1.date_from AS exam_1_date_from
#     ,exam_1.date_to AS exam_1_date_to
#     ,exam_1.created AS exam_1_created
#     ,exam_1.created_by_ AS exam_1_created_by_
#     ,exam_1.duration AS exam_1_duration
#     ,exam_1.success_threshold AS exam_1_success_threshold
#     ,exam_1.published AS exam_1_published
#   FROM
#     rel_users_exams LEFT OUTER JOIN exam AS exam_1
#       ON exam_1.id = rel_users_exams.exam_id
#   WHERE
#     1 = rel_users_exams.exam_id
# ;
#
# query plan:
#
# Nested Loop Left Join  (cost=11.95..28.52 rows=5 width=157) (actual time=0.010..0.010 rows=0 loops=1)
#   Output: rel_users_exams.user_username, rel_users_exams.exam_id, rel_users_exams.started_at, rel_users_exams.finished_at, exam_1.id, exam_1.title, exam_1.date_from, exam_1.date_to, exam_1.created, exam_1.created_by_, exam_1.duration, exam_1.success_threshold, exam_1.published
#   Inner Unique: true
#   Join Filter: (exam_1.id = rel_users_exams.exam_id)
#   Buffers: shared hit=1
#   ->  Bitmap Heap Scan on public.rel_users_exams  (cost=11.80..20.27 rows=5 width=52) (actual time=0.009..0.009 rows=0 loops=1)
#         Output: rel_users_exams.user_username, rel_users_exams.exam_id, rel_users_exams.started_at, rel_users_exams.finished_at
#         Recheck Cond: (1 = rel_users_exams.exam_id)
#         Buffers: shared hit=1
#         ->  Bitmap Index Scan on rel_users_exams_pkey  (cost=0.00..11.80 rows=5 width=0) (actual time=0.005..0.005 rows=0 loops=1)
#               Index Cond: (1 = rel_users_exams.exam_id)
#               Buffers: shared hit=1
#   ->  Materialize  (cost=0.15..8.17 rows=1 width=105) (never executed)
#         Output: exam_1.id, exam_1.title, exam_1.date_from, exam_1.date_to, exam_1.created, exam_1.created_by_, exam_1.duration, exam_1.success_threshold, exam_1.published
#         ->  Index Scan using exam_pkey on public.exam exam_1  (cost=0.15..8.17 rows=1 width=105) (never executed)
#               Output: exam_1.id, exam_1.title, exam_1.date_from, exam_1.date_to, exam_1.created, exam_1.created_by_, exam_1.duration,
# exam_1.success_threshold, exam_1.published
#               Index Cond: (exam_1.id = 1)
# Planning Time: 1.110 ms
# Execution Time: 0.170 ms
# 
# ┗--------------------------------------------------------------------------------
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/coderberry/whoop. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/coderberry/whoop/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Whoop project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/coderberry/whoop/blob/main/CODE_OF_CONDUCT.md).

## Attribution

This project is maintained by [Eric Berry](https://linktr.ee/coderberry).

This gem is based on the [wrapped_print](https://github.com/igorkasyanchuk/wrapped_print) gem by [Igor Kasyanchuk](https://www.railsjazz.com/).
