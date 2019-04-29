# frozen_string_literal: true

require 'open3'

module SystemCall
  ##
  # A class responsible for communication with command line interfaces.
  #
  # @!attribute [r] args
  #   @return [Array]
  class Command
    attr_reader :args

    ##
    # Initializes a {Command}.
    #
    # @param args [Array] The command line arguments.
    def initialize(*args)
      @args = args.flatten
    end

    ##
    # Initializes and calls a {Command}, then returns the {Result}.
    #
    # @param args [Array] The command line arguments.
    # @return [Result]
    def self.call(*args)
      new(*args).call
    end

    ##
    # Invokes the {Command} and returns the {Result}.
    #
    # @return [Result]
    def call
      Open3.popen3(*args) do |_, stdout, stderr, wait_thr|
        success_result = readlines(stdout)
        error_result = readlines(stderr)
        exit_status = wait_thr.value
        Result.new(exit_status, success_result, error_result)
      end
    end

    private

    def readlines(io)
      io.readlines.join.chomp
    end
  end
end
