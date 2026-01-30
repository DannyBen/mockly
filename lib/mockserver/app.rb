require 'sinatra/base'
require 'json'
require 'mime/types'

module Mockserver
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

    helpers do
      def candidates(path, method)
        clean = path.gsub(%r{/$}, '')
        base = File.basename(clean)
        dir = File.dirname(clean)
        method_tag = method.downcase

        dir = '' if dir == '.'
        full_dir = dir.empty? ? settings.mock_root : "#{settings.mock_root}/#{dir}"

        [
          "#{full_dir}/#{method_tag}-#{base}.json",
          "#{full_dir}/#{base}/#{method_tag}.json",
          "#{full_dir}/#{base}.json",
        ]
      end

      def resolve_mock(path, method)
        candidates(path, method).find { |file| File.file?(file) }
      end

      def resolve_asset(path)
        file = File.expand_path path, settings.asset_root
        return nil unless file.start_with?(settings.asset_root)

        File.file?(file) ? file : nil
      end
    end

    %w[GET POST PUT PATCH DELETE OPTIONS].each do |verb|
      send(verb.downcase, '/*') do
        req_path = params['splat'].first

        exact = File.expand_path req_path, settings.mock_root

        if exact.start_with?(settings.mock_root) && File.file?(exact)
          content_type MIME::Types.type_for(exact).first.to_s
          return send_file exact
        end

        file = resolve_mock req_path, request.request_method
        return File.read file if file

        status 404
        JSON.dump error: "No mock for #{request.request_method} #{request.path}"
      end
    end
  end
end
