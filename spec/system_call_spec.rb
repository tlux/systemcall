# frozen_string_literal: true

describe SystemCall do
  describe '::VERSION' do
    it 'is defined' do
      expect(described_class::VERSION).not_to be nil
    end
  end

  describe '.call' do
    it 'delegates to Command' do
      args = double('args')
      result = double('result')

      allow(described_class::Command)
        .to receive(:call).with(args).and_return(result)

      expect(described_class.call(args)).to be result
    end
  end

  describe '#system_call' do
    it 'delegates to Command' do
      args = double('args')
      result = double('result')

      allow(described_class::Command)
        .to receive(:call).with(args).and_return(result)

      target_class = Class.new { extend SystemCall }
      other_target_class = Class.new { include SystemCall }
      target_obj = other_target_class.new

      expect(target_class.system_call(args)).to be result
      expect(target_obj.system_call(args)).to be result
    end
  end
end
