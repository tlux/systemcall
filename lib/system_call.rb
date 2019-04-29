# frozen_string_literal: true

require 'system_call/version'

##
# A simple wrapper around Ruby's Open3 to call CLI programs and process their
# output.
module SystemCall
  autoload :Command, 'system_call/command'
  autoload :Result, 'system_call/result'

  module_function

  ##
  # Initializes and calls a {Command}, then returns the {Result}.
  #
  # @param args [Array] The command line arguments.
  # @return [Result]
  def call(*args)
    Command.call(*args)
  end
end
