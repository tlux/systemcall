# frozen_string_literal: true

describe SystemCall::Result do
  it 'includes Comparable' do
    expect(described_class).to include Comparable
  end

  let(:exit_status) { double('exit status') }
  let(:success_result) { double('success result') }
  let(:error_result) { double('error result') }

  subject do
    described_class.new(exit_status, success_result, error_result)
  end

  describe '#initialize' do
    it 'stores first arg in #exit_status' do
      expect(subject.exit_status).to be exit_status
    end

    it 'stores second arg in #success_result' do
      expect(subject.success_result).to be success_result
    end

    it 'stores third arg in #error_result' do
      expect(subject.error_result).to be error_result
    end
  end

  describe '#exit_code' do
    it 'gets exit code from process status' do
      exit_code = 666
      allow(exit_status).to receive(:exitstatus).and_return(exit_code)

      expect(subject.exit_code).to eq(exit_code)
    end
  end

  describe '#success?' do
    it 'is true when #exit_status indicates success' do
      allow(exit_status).to receive(:success?).and_return(true)

      expect(subject.success?).to be true
    end

    it 'is false when #exit_status indicates failure' do
      allow(exit_status).to receive(:success?).and_return(false)

      expect(subject.success?).to be false
    end
  end

  describe '#error?' do
    it 'is true when #success? is false' do
      allow(subject).to receive(:success?).and_return(false)

      expect(subject.error?).to be true
    end

    it 'is false when #success? is true' do
      allow(subject).to receive(:success?).and_return(true)

      expect(subject.error?).to be false
    end
  end

  describe '#result' do
    it 'returns #success_result when #success? is true'

    it 'returns #error_result when #success? is false'
  end

  describe '#to_s' do
    it 'is an alias for #result'
  end

  describe '#<=>' do
    it 'is nil when other object is nil'

    it 'compares result with #to_s of other object'
  end
end
