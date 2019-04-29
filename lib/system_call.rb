# frozen_string_literal: true

require 'system_call/version'

module SystemCall
  autoload :Command, 'system_call/command'
  autoload :NotCalledError, 'system_call/not_called_error'

  module_function

  def call(*args)
    Command.call(*args)
  end
end
