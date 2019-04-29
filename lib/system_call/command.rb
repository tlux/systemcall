# frozen_string_literal: true

require 'open3'

module SystemCall
  ##
  # A class responsible for communication with command line interfaces.
  #
  # @!attribute [r] args
  #   @return [Array]
  # @!attribute [r] success_result
  #   @return [String, nil] The STDOUT output of the called command.
  # @!attribute [r] error_result
  #   @return [String, nil] The STDERR output of the called command.
  # @!attribute [r] exit_status
  #   @return [Process::Status, nil] The exit status of the called command.
  class Command
    attr_reader :args, :success_result, :error_result, :exit_status

    ##
    # Initializes the {SystemCall}.
    #
    # @param args [Array<String>] The command line arguments.
    def initialize(*args)
      @args = args.flatten
    end

    ##
    # Initializes and calls the {SystemCall}.
    #
    # @param args [Array<String>] The command line arguments.
    # @return [SystemCall]
    def self.call(*args)
      new(*args).call
    end

    ##
    # Calls the command.
    #
    # @return [Command]
    def call
      Open3.popen3(*args) do |_, stdout, stderr, wait_thr|
        @success_result = readlines(stdout)
        @error_result = readlines(stderr)
        @exit_status = wait_thr.value
      end
      self
    end

    ##
    # Determines whether the command has been called.
    #
    # @return [Boolean]
    def called?
      !exit_status.nil?
    end

    ##
    # Indicates whether the command has been executed successfully.
    #
    # @raise [NotCalledError] Raises when the command has not yet been called.
    # @return [Boolean]
    def success?
      raise NotCalledError, self unless called?

      exit_status.success?
    end

    ##
    # Indicates whether the command has not been executed successfully.
    #
    # @raise [RuntimeError] Raises when the command has not yet been called.
    # @return [true, false]
    def error?
      !success?
    end

    ##
    # Returns the command result.
    #
    # @return [String] Returns result from {#success_result} when command exited
    #   successfully. Otherwise returns result from {#error_result}.
    # @raise [RuntimeError] Raises when the command has not yet been called.
    def result
      success? ? success_result : error_result
    end

    private

    def readlines(io)
      io.readlines.join.chomp
    end
  end
end
