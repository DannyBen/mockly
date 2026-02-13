require 'json'
require 'yaml'

module Mockly
  class Router
    attr_reader :mock_root

    def initialize(mock_root:)
      @mock_root = mock_root
    end

    def resolve(req_path:, method:, request_path:)
      file = resolve_from_file req_path, method
      return File.read file if file

      resolve_from_config method, request_path
    end

  private

    def resolve_from_file(path, method)
      candidates(path, method).find { |file| File.file?(file) }
    end

    def resolve_from_config(method, path)
      config = route_config
      key = route_lookup_keys(method, path).find { |candidate| config.has_key?(candidate) }
      return nil unless key

      JSON.dump config[key]
    end

    def candidates(path, method)
      clean = path.gsub %r{/$}, ''
      base = File.basename clean
      dir = File.dirname clean
      method_tag = method.downcase

      dir = '' if dir == '.'
      full_dir = dir.empty? ? mock_root : "#{mock_root}/#{dir}"

      [
        "#{full_dir}/#{method_tag}-#{base}.json",
        "#{full_dir}/#{base}/#{method_tag}.json",
        "#{full_dir}/#{base}.json",
      ]
    end

    def route_index_files
      %w[index.yml index.yaml].flat_map do |name|
        [
          File.join(mock_root, name),
          File.join(Dir.pwd, name),
        ]
      end.uniq
    end

    def route_config
      file = route_index_files.find { |candidate| File.file?(candidate) }
      return {} unless file

      data = YAML.safe_load_file(file, permitted_classes: [], aliases: true) || {}
      data.is_a?(Hash) ? data : {}
    rescue Psych::Exception
      {}
    end

    def route_lookup_keys(method, path)
      normalized = path.gsub(%r{/$}, '')
      normalized = '/' if normalized.empty?

      keys = ["#{method.upcase} #{path}"]
      keys << "#{method.upcase} #{normalized}" unless normalized == path
      keys
    end
  end
end
