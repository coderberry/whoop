require "sqlite3"

module Whoop
  module Persistable
    extend ActiveSupport::Concern

    class_methods do
      def save_message(content: nil, title: nil, caller: nil, format: nil, explain: nil, created_at: Time.now.utc)
        return unless content.present?

        sql = "INSERT INTO whoop_messages (?, ?, ?, ?, ?, ?, ?)"
        db.execute(sql, {
          content: content,
          title: title,
          caller: caller,
          format: format,
          explain: explain,
          created_at: created_at,
          updated_at: created_at
        })
      end

      def db
        puts "DB PATH: #{db_path}"
        @db ||= SQLite3::Database.new(db_path)
      end

      def db_path
        @db_path ||= File.join(File.dirname(__FILE__), "../../spec/dummy/db/#{Rails.env}.sqlite3")
      end
    end
  end
end
