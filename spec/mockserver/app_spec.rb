require 'rack/test'
require 'json'

describe Mockserver::App do
  let(:mock_root) { File.expand_path('../fixtures/mocks', __dir__) }

  before do
    described_class.set :mock_root, mock_root
    described_class.set :asset_root, File.join(mock_root, 'assets')
  end

  describe 'GET /' do
    it 'serves the root mock json' do
      get '/'

      expect(last_response.status).to eq(200)
      expect(last_response.content_type).to eq 'application/json'
      expect(last_response.body).to eq File.read 'spec/fixtures/mocks/get.json'
    end
  end

  describe 'GET /chat/completions' do
    it 'serves a nested mock json file' do
      get '/chat/completions'

      expect(last_response.status).to eq(200)
      expect(last_response.content_type).to eq 'application/json'
      expect(last_response.body).to eq File.read 'spec/fixtures/mocks/chat/completions.json'
    end
  end

  describe 'GET /assets/image.jpg' do
    it 'serves a static asset file' do
      get '/assets/image.jpg'

      expect(last_response.status).to eq(200)
      expect(last_response.content_type).to eq 'image/jpeg'
      expect(last_response.body).to eq File.binread('spec/fixtures/mocks/assets/image.jpg')
    end
  end

  describe 'GET /missing' do
    it 'returns a 404 with a JSON error' do
      get '/missing'

      expect(last_response.status).to eq(404)
      expect(last_response.content_type).to eq 'application/json'
      expect(last_response.body).to eq({ 'error' => 'No mock for GET /missing' }.to_json)
    end
  end
end
