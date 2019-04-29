# frozen_string_literal: true

module SystemCall
  ##
  # A class that represents a result of a system call.
  #
  # @!attribute [r] exit_status
  #   @return [Process::Status] The exit status of the result.
  # @!attribute [r] success_result
  #   @return [String] The STDOUT of the result.
  # @!attribute [r] error_result
  #   @return [String] The STDERR of the result.
  class Result
    include Comparable

    attr_reader :exit_status, :success_result, :error_result

    ##
    # Initializes a new {Result}.
    #
    # @param exit_status [Process::Status] The exit status of the result.
    # @param success_result [String] The STDOUT of the result.
    # @param error_result [String] The STDERR of the result.
    def initialize(exit_status, success_result, error_result)
      @exit_status = exit_status
      @success_result = success_result
      @error_result = error_result
    end

    ##
    # Indicates whether the command has been executed successfully.
    #
    # @raise [NotCalledError] Raises when the command has not yet been called.
    # @return [Boolean]
    def success?
      exit_status.success?
    end

    ##
    # Gets the exit code of the process.
    #
    # @return [Integer]
    def exit_code
      exit_status.exitstatus
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

    alias to_s result

    ##
    # Compares the result with the result of {#to_s} from another object.
    #
    # @param other [#to_s, nil]
    # @return [Integer, nil]
    def <=>(other)
      return nil if other.nil?

      result <=> other.to_s
    end
  end
end
