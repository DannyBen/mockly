describe 'bin/mockly' do
  context 'when an exception occurs' do
    it 'errors gracefully' do
      expect(`bin/mockly --port 10 2>&1`.size).to be < 600
    end
  end
end
