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

        expect(logged_message.uncolorize).to match %r{^┆ timestamp:.*}
        expect(logged_message.uncolorize).to match %r{^┆ source:.*}
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

    context "when the format is invalid" do
      it "adds a note listing available formats" do
        io = setup_whoop
        whoop("Bad format", format: :invalid, color: false)
        logged_message = io.string

        puts logged_message

        expect(logged_message).to include('Bad format')
        expect(logged_message).to include('Unsupported format used. Available formats: plain, json, and sql')
      end
    end

    context "when the format is :json" do
      it "writes to the logger" do
        io = setup_whoop
        whoop({hello: "world"}, format: :json, color: false)
        logged_message = io.string

        puts logged_message

        expect(logged_message).to include('"hello": "world"')
        expect(logged_message).not_to include('Unsupported format used.')
      end
    end

    context "when the format is :sql" do
      it "writes to the logger" do
        io = setup_whoop
        sql = 'SELECT emp_id, first_name,last_name,dept_id,mgr_id, WIDTH_BUCKET(department_id,20,40,10) "Exists in Dept" FROM emp WHERE mgr_id < 300 ORDER BY "Exists in Dept"'
        whoop(sql, format: :sql, color: :blue)
        logged_message = io.string

        puts logged_message

        expect(logged_message).to include("SELECT")
        expect(logged_message).not_to include('Unsupported format used.')
      end
    end

    context "when context is passed" do
      it "writes to the logger" do
        io = setup_whoop
        context = {
          current_user: "Eric",
          ip_address: "127.0.0.1"
        }
        whoop("With Context", context: context) { "Should include context" }
        logged_message = io.string

        puts logged_message

        context.each do |k, v|
          expect(logged_message.uncolorize).to include "#{k}: #{v}"
        end
      end
    end

    context "when invalid context is passed" do
      it "writes to the logger" do
        io = setup_whoop
        context = "This is not a hash"
        whoop("With Invalid Context", context: context) { "Should not include context" }
        logged_message = io.string

        puts logged_message

        expect(logged_message).not_to include(context)
      end
    end

    context 'parsing PostgreSQL operators' do
      it 'appropriately formats jsonb column operators' do
        io = setup_whoop

        [
          %Q['{"a": {"b":"foo"}}'::json -> 'a'],
          %Q['[1,2,3]'::json ->> 2],
          %Q['{"a":1,"b":2}'::json ->> 'b'],
          %Q['{"a": {"b":{"c": "foo"}}}'::json #> '{a,b}'],
          %Q['{"a":[1,2,3],"b":[4,5,6]}'::json #>> '{a,2}']
          # ... all examples from https://www.postgresql.org/docs/9.5/functions-json.html
        ].each do |token|
          whoop(token, format: :sql, color: false)
          logged_message = io.string

          expect(logged_message.uncolorize).to include(token)
        end
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
