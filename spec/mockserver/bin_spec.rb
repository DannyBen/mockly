describe 'bin/mockserver' do
  context 'when an exception occurs' do
    it 'errors gracefully' do
      expect(`bin/mockserver --port 10 2>&1`)
        .to match_approval('cli/exception')
        .except(/PID: (.*)/, 'PID: ...')
    end
  end
end
