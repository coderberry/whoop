# frozen_string_literal: true

module Whoop
  class ViewerController < ApplicationController
    def index
      @messages = Message.all
    end

    def show
    end
  end
end
