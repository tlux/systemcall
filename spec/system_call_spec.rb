# frozen_string_literal: true

describe SystemCall do
  describe '::VERSION' do
    it 'is defined' do
      expect(described_class::VERSION).not_to be nil
    end
  end
end
