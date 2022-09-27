# frozen_string_literal: true

class CreateWhoopMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :whoop_messages do |t|
      t.string :content
      t.string :title
      t.string :caller
      t.string :format
      t.string :explain

      t.timestamps
    end
  end
end
