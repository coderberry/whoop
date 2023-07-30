# frozen_string_literal: true

module Whoop
  class TraceResponse
    attr_reader :results, :trace_events, :traces

    def initialize(results: nil, trace_events: [], traces: nil)
      @results = results
      @trace_events = trace_events
      @traces = traces
    end
  end
end
