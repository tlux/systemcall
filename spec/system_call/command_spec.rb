# frozen_string_literal: true

describe SystemCall::Command do
  describe '#initialize' do
    it 'stores args in #args' do
      args = %w[arg1 arg2 arg3]
      command = described_class.new(*args)

      expect(command.args).to eq args
    end

    it 'stores first Array arg in #args' do
      args = %w[arg1 arg2 arg3]
      command = described_class.new(args)

      expect(command.args).to eq args
    end

    it 'flattens first Array arg and stores result in #args' do
      args = [[%w[arg1 arg2], 'arg3'], 'arg4']
      command = described_class.new(args)

      expect(command.args).to eq args.flatten
    end
  end

  describe '.call' do
    it 'initializes Command and invokes #call' do
      args = double('args')
      command = double('command')
      result = double('result')

      expect(described_class).to receive(:new).with(args).and_return(command)
      expect(command).to receive(:call).and_return(result)

      expect(described_class.call(args)).to be result
    end
  end

  describe '#call' do
    let(:args) { %w[arg1 arg2 arg3] }
    subject { described_class.new(*args) }

    it 'calls Open3.popen with #args as arguments' do
      expect(Open3).to receive(:popen3).with(*args)

      subject.call
    end

    context 'result' do
      let(:exit_status) { double('exit status') }
      let(:success_result) { "success 1\nsuccess 2" }
      let(:error_result) { "error 1\nerror 2" }

      before do
        success_io = build_mock_io(success_result)
        error_io = build_mock_io(error_result)
        wait_thr = double('wait thread', value: exit_status)

        allow(Open3)
          .to receive(:popen3)
          .with(*args)
          .and_yield(nil, success_io, error_io, wait_thr)
      end

      let!(:result) { subject.call }

      it 'contains exit status' do
        expect(result.exit_status).to eq exit_status
      end

      it 'contains success result' do
        expect(result.success_result).to eq success_result
      end

      it 'contains error result' do
        expect(result.error_result).to eq error_result
      end

      def build_mock_io(*lines)
        io = StringIO.new
        lines.flatten.each { |line| io.puts(line) }
        io.tap(&:rewind)
      end
    end
  end
end
