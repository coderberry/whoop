# frozen_string_literal: true

Rails.application.routes.draw do
  mount Whoop::Engine => "/whoop"
end
