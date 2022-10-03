# frozen_string_literal: true

module Whoop
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
  end
end
