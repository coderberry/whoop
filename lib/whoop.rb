# frozen_string_literal: true

require "active_support"
require "colorize"
require "rouge"
require_relative "whoop/version"
require_relative "whoop/tracer"
require_relative "whoop/trace_response"
require_relative "whoop/formatters/json_formatter"
require_relative "whoop/formatters/pretty_formatter"
require_relative "whoop/formatters/sql_formatter"

# Whoop.setup do |config|
#   config.logger = ActiveSupport::Logger.new("#{Rails.root}/log/debug.log")
#   config.level = :debug
# end

module Whoop
  mattr_accessor :logger
  @@logger = ActiveSupport::Logger.new($stdout)

  mattr_accessor :level
  @@level = :debug

  # Configure the logger
  # @yield [Whoop::Configuration] The configuration object
  def self.setup
    yield(self)
  end

  module Main
    COLORS = %i[black red green yellow blue magenta cyan white light_black light_red light_green light_yellow light_blue light_magenta light_cyan light_white default].freeze
    FORMATS = %i[plain pretty json sql trace].freeze
    TRACE_EVENTS = %i[line class end call return c_call c_return raise b_call b_return thread_begin thread_end fiber_switch script_compiled].freeze
    PATTERN = "-"
    COUNT = 80
    INDENT = "┆"
    TOP_LINE_CHAR = "┏"
    BOTTOM_LINE_CHAR = "┗"

    # Log the message to the logger
    # @param [String] label (optional) - the label or object to log
    # @param [String] pattern - the pattern to use for the line (e.g. '-')
    # @param [Integer] count - the number of times to repeat the pattern per line (e.g. 80)
    # @param [Symbol] color - the color to use for the line (e.g. :red)
    # @param [Symbol] format - the format to use for the message (one of :json, :sql, :plain, :pretty (default))
    # @param [Integer] caller_depth - the depth of the caller to use for the source (default: 0)
    # @param [Boolean] explain - whether to explain the SQL query (default: false)
    # @param [Array<Symbol>] trace_events - events to trace block execution
    # @param [Hash] context - Any additional context you'd like to include in the log
    def whoop(
      label = nil,
      pattern: PATTERN,
      count: COUNT,
      color: :default,
      format: :pretty,
      caller_depth: 0,
      explain: false,
      trace_events: [],
      context: nil
    )
      logger_method = detect_logger_method
      color_method = detect_color_method(color)

      formatter_method = detect_formatter_method(format, colorize: color.present?, explain: explain)

      line = pattern * count
      caller_path = clean_caller_path(caller[caller_depth])
      caller_path_line = [color_method.call(INDENT), "source:".colorize(:light_black).underline, caller_path].join(" ")
      timestamp_line = [color_method.call(INDENT), "timestamp:".colorize(:light_black).underline, Time.now].join(" ")

      context_lines =
        if context.is_a?(Hash) && context.keys.length > 0
          context.map do |k, v|
            [color_method.call(INDENT), "#{k}:".colorize(:light_black).underline, v].join(" ")
          end
        else
          []
        end

      if block_given?
        io = StringIO.new
        results = 
          if format == :trace
            trace_events = trace_events.any? ? trace_events : [:call]
            result, io = Tracer.start_trace(io, trace_events) { yield }
          else
            yield
          end

        require "pry"
        binding.pry

        # result = nil
        # traced_events = []
        # if trace_method
        #   trace_results = trace_method.call(label) { yield }
        #   result = trace_results[:result]
        #   traced_events = trace_results[:traced_events]
        # else
        #   result = yield
        # end
        #
        top_line =
          if label.present? && label.is_a?(String)
            wrapped_line(label.to_s, pattern: pattern, count: count)
          else
            pattern * count
          end
        result.tap do
          logger_method.call color_method.call "\n\n#{TOP_LINE_CHAR}#{top_line}"
          logger_method.call timestamp_line
          logger_method.call caller_path_line
          context_lines.each { |l| logger_method.call l }
          logger_method.call ""
          logger_method.call formatter_method.call(result)
          logger_method.call ""
          display_invalid_format_message(format, color_method, logger_method)
          logger_method.call color_method.call "#{BOTTOM_LINE_CHAR}#{line}\n\n"
        end
      else
        tap do
          logger_method.call color_method.call "\n\n#{TOP_LINE_CHAR}#{line}"
          logger_method.call timestamp_line
          logger_method.call caller_path_line
          context_lines.each { |l| logger_method.call l }
          logger_method.call ""
          logger_method.call formatter_method.call(label)
          logger_method.call ""
          display_invalid_format_message(format, color_method, logger_method)
          logger_method.call color_method.call "#{BOTTOM_LINE_CHAR}#{line}\n\n"
        end
      end
    end

    private

    # Remove the Rails.root from the caller path
    # @param [String] caller_path - path of the the file and line number of the caller
    # @return [String]
    def clean_caller_path(caller_path)
      return caller_path unless defined?(Rails)

      caller_path.gsub(Rails.root.to_s, "")
    end

    # Detect the colorize method to use
    # @param [Symbol] color
    # @return [Method] the colorize method
    def detect_color_method(color)
      return ->(message) { message } unless color

      color = color.to_sym
      raise ArgumentError, "Invalid color: #{color}. Must be one of #{COLORS}" unless COLORS.include?(color)

      ->(message) { message.colorize(color) }
    end

    # Detect the logger method to use
    # @return [Method] logger method
    def detect_logger_method
      if Whoop.logger.respond_to?(Whoop.level)
        Whoop.logger.method(Whoop.level)
      else
        method(:puts)
      end
    end

    # Return the format method to use
    # @param [Symbol] format
    # @return [Method] format method
    def detect_formatter_method(format, colorize: false, explain: false)
      case format.to_sym
      when :json
        ->(message) { Whoop::Formatters::JsonFormatter.format(message, colorize: colorize) }
      when :sql
        ->(message) { Whoop::Formatters::SqlFormatter.format(message, colorize: colorize, explain: explain) }
      when :pretty
        ->(message) { Whoop::Formatters::PrettyFormatter.format(message) }
      when :trace
          ->(trace_response) { Whoop::Formatters::TraceFormatter.format(trace_response) }
      else
        ->(message) { message }
      end
    end

    def display_invalid_format_message(format, color_method, logger_method)
      return if FORMATS.include?(format)

      invalid_format_line = [color_method.call(INDENT), "note:".colorize(:blue).underline, "Unsupported format used. Available formats: #{FORMATS.to_sentence}"].join(" ")
      logger_method.call invalid_format_line
    end

    # Return the line with the label centered in it
    # @param [String] label
    # @param [Integer] count
    # @param [String] pattern
    # @return [String]
    def wrapped_line(label, count: COUNT, pattern: PATTERN)
      line_part_length = [((count - label.length) / 2.0).to_i, 5].max
      line_part = pattern * line_part_length
      [line_part, label, line_part].join(" ")
    end
  end
end

Object.send :include, Whoop::Main
