require_relative '../spec_helper'

RSpec.describe LogfileParser do
  let(:logfile_path) { 'spec/fixtures/webserver_sample.log' }
  subject { described_class.new(logfile_path) }

  describe 'initialized without logfile' do
    let(:logfile_path) { 'fake/path/to/file.log' }

    it 'raises an error', :skip_before do
      expect { subject }.to
        raise_error(RuntimeError, "No such file or directory @ #{logfile_path}")
    end
  end

  describe '#parse' do
    before { subject.parse }

    let(:expected_results) do
      {
        '/index'   => ['444.701.448.104', '444.701.448.104', '126.318.035.038'],
        '/contact' => ['184.123.665.067'],
        '/about'   => ['126.318.035.038'],
        '/about/2' => ['836.973.694.403'],
        '/home'    => ['897.280.786.156', '715.156.286.412']
      }
    end

    it "parses the data correctly" do
      expect(subject.entries).to eq(expected_results)
    end
  end

  describe '#most_views' do
    before { subject.parse }

    let(:expected_results) do
      {
        '/index'   => 3,
        '/home'    => 2,
        '/about'   => 1,
        '/about/2' => 1,
        '/contact' => 1
      }
    end

    it 'returns the correct values' do
      expect(subject.most_views).to eq(expected_results)
    end
  end

  describe '#unique_views' do
    before { subject.parse }

    let(:expected_results) do
      {
        '/home'    => 2,
        '/index'   => 2,
        '/about'   => 1,
        '/about/2' => 1,
        '/contact' => 1
      }
    end

    it 'returns the correct values' do
      expect(subject.unique_views).to eq(expected_results)
    end
  end
end
