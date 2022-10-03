# frozen_string_literal: true

class CreateWhoopMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :whoop_messages do |t|
      t.string :label
      t.text :content, null: false
      t.text :query_plan
      t.string :pattern
      t.integer :count
      t.string :color
      t.string :format
      t.string :caller_path
      t.text :context

      t.datetime :created_at
    end
  end
end
