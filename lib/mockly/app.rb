require 'sinatra/base'
require 'json'
require 'mime/types'

module Mockly
  class App < Sinatra::Base
    configure do
      set :bind, '0.0.0.0'
      set :port, 3000
      set :server, :puma
      set :environment, :production
      set :mock_root, File.expand_path('mocks', Dir.pwd)
      set :asset_root, File.join(settings.mock_root, 'assets')
    end

    before do
      content_type 'application/json'
    end

    %w[GET POST PUT PATCH DELETE OPTIONS].each do |verb|
      send(verb.downcase, '/*') do
        req_path = params['splat'].first

        exact = File.expand_path req_path, settings.mock_root

        if exact.start_with?(settings.mock_root) && File.file?(exact)
          content_type MIME::Types.type_for(exact).first.to_s
          return send_file exact
        end

        router = Mockly::Router.new(mock_root: settings.mock_root)
        route = router.resolve(
          req_path: req_path,
          method: request.request_method,
          request_path: request.path,
        )

        return route if route

        status 404
        JSON.dump error: "No mock for #{request.request_method} #{request.path}"
      end
    end
  end
end
