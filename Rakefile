# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)
GEM_NAME = "whoop"
GEM_VERSION = Whoop::VERSION

require "standard/rake"
require "bump/tasks"

task default: %i[spec standard]

task :build do
  system "gem build #{GEM_NAME}.gemspec"
end

task install: :build do
  system "gem install #{GEM_NAME}-#{GEM_VERSION}.gem"
end

task publish: :build do
  system "gem push #{GEM_NAME}-#{GEM_VERSION}.gem"
  system "gem push --key github --host https://rubygems.pkg.github.com/coderberry #{GEM_NAME}-#{GEM_VERSION}.gem"
end

task :clean do
  system "rm *.gem"
end
