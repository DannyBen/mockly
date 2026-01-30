describe Mockserver::CLI do
  describe '::runner' do
    it 'returns a MisterBin::Runner instance' do
      expect(described_class.runner).to be_a MisterBin::Runner
    end
  end
end
