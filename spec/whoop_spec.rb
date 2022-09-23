# frozen_string_literal: true

RSpec.describe Whoop do
  it "has a version number" do
    expect(Whoop::VERSION).not_to be nil
  end

  describe ".whoop" do
    context "when the label is a string" do
      it "writes to the logger" do
        io = setup_whoop
        whoop("Hello")
        logged_message = io.string

        puts logged_message

        expect(logged_message.uncolorize).to match %r{^timestamp:.*}
        expect(logged_message.uncolorize).to match %r{^source:.*}
        expect(logged_message.uncolorize).to include("Hello")
      end
    end

    context "when the label and block are both passed in" do
      it "writes to the logger" do
        io = setup_whoop
        whoop("My Label", color: :green) { "Hello" }
        logged_message = io.string

        puts logged_message

        expect(logged_message.uncolorize).to include "---- My Label ----"
        expect(logged_message.uncolorize).to include "Hello"
      end
    end

    context "when the format is :json" do
      it "writes to the logger" do
        io = setup_whoop
        whoop({hello: "world"}, format: :json, color: false)
        logged_message = io.string

        puts logged_message

        expect(logged_message).to include('"hello": "world"')
      end
    end

    context "when the format is :sql" do
      it "writes to the logger" do
        io = setup_whoop
        sql = 'SELECT emp_id, first_name,last_name,dept_id,mgr_id, WIDTH_BUCKET(department_id,20,40,10) "Exists in Dept" FROM emp WHERE mgr_id < 300 ORDER BY "Exists in Dept"'
        whoop(sql, format: :sql)
        logged_message = io.string

        puts logged_message

        expect(logged_message).to include("SELECT")
      end
    end
  end

  private

  def setup_whoop
    io = StringIO.new

    Whoop.setup do |config|
      config.logger = ActiveSupport::Logger.new(io)
      config.level = :debug
    end

    io
  end
end
