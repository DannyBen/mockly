require 'mister_bin'

module Mockly
  class CLI
    def self.runner
      MisterBin::Runner.new header: 'Mockly - Mock Server for API Testing',
        handler: Command
    end
  end
end
