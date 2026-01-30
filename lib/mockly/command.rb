require 'mister_bin'

module Mockly
  class Command < MisterBin::Command
    summary 'Start the mock server'

    version VERSION

    usage 'mockly [--port N --host IP --root PATH]'
    usage 'mockly (-h|--help)'

    option '-p --port N', 'Port number [default: 3000]'
    option '-b --host IP', 'Binding address [default: 0.0.0.0]'
    option '-r --root PATH', 'Root mocks directory [default: ./mocks]'

    def run
      port = (args['--port']).to_i
      host = args['--host']
      mock_root = File.expand_path args['--root']

      App.set :bind, host
      App.set :port, port
      App.set :mock_root, mock_root
      App.set :asset_root, File.join(mock_root, 'assets')

      App.run!
    end
  end
end
