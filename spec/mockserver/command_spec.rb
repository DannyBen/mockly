describe Mockserver::Command do
  subject { described_class.new }

  describe '--help' do
    it 'shows long usage' do
      expect { subject.execute %w[--help] }
        .to output_approval('command/help')
    end
  end

  describe 'server start' do
    it 'applies the requested config and starts the server' do
      mock_root = File.expand_path('tmp')

      expect(Mockserver::App).to receive(:set).with(:bind, '127.0.0.1')
      expect(Mockserver::App).to receive(:set).with(:port, 4000)
      expect(Mockserver::App).to receive(:set).with(:mock_root, mock_root)
      expect(Mockserver::App).to receive(:set).with(:asset_root, File.join(mock_root, 'assets'))
      expect(Mockserver::App).to receive(:run!)

      subject.execute %w[--port 4000 --host 127.0.0.1 --root tmp]
    end
  end
end
