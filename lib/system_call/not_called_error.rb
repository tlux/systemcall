# frozen_string_literal: true

module SystemCall
  class NotCalledError < StandardError
    attr_reader :command

    def initialize(command)
      @command = command
      super('Command not invoked')
    end
  end
end
