# frozen_string_literal: true

module Whoop
  class Message < ApplicationRecord
    validates :content, presence: true
  end
end
