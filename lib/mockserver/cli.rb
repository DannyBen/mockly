require 'mister_bin'

module Mockserver
  class CLI
    def self.runner
      MisterBin::Runner.new header: 'Mockserver - Server for API Testing',
        handler: Command
    end
  end
end
