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

      expect(described_class.call(args)).to be(result)
    end
  end
end
