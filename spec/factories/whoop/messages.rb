# frozen_string_literal: true

FactoryBot.define do
  factory :message do
    label { "MyString" }
    pattern { "MyString" }
    count { 1 }
    color { "MyString" }
    format { "MyString" }
    caller_path { "MyString" }
    explain { false }
    context { "MyText" }
  end
end
