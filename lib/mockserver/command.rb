require 'mister_bin'

module Mockserver
  class Command < MisterBin::Command
    summary 'Start the mock server'

    usage 'mockserver [--port N --host IP --root PATH]'
    usage 'mockserver (-h|--help)'

    option '-p --port N', 'Port number [default: 3000]'
    option '-b --host IP', 'Binding address [default: 0.0.0.0]'
    option '-r --root PATH', 'Root mocks directory [default: ./mocks]'

    def run
      puts "ok"
    end
  end
end
