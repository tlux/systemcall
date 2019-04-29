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
    it 'returns #success_result when #success? is true' do
      allow(subject).to receive(:success?).and_return(true)

      expect(subject.result).to be success_result
    end

    it 'returns #error_result when #success? is false' do
      allow(subject).to receive(:success?).and_return(false)

      expect(subject.result).to be error_result
    end
  end

  describe '#to_s' do
    it 'is an alias for #result' do
      expect(subject.method(:to_s)).to eq subject.method(:result)
    end
  end

  describe '#<=>' do
    before do
      allow(subject).to receive(:result).and_return('b')
    end

    it 'is nil when other object is nil' do
      expect(subject <=> nil).to be_nil
    end

    it 'compares result with other String' do
      expect(subject <=> 'a').to eq(1)
      expect(subject <=> 'b').to eq(0)
      expect(subject <=> 'c').to eq(-1)
    end

    it 'compares result with #to_s of other object' do
      { 'a' => 1, 'b' => 0, 'c' => -1 }.each do |char, value|
        other = double('other', to_s: char)
        expect(subject <=> other).to eq(value)
      end
    end
  end
end
