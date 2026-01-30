require 'rack/test'
require 'json'

describe Mockly::App do
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

  describe 'candidate order' do
    it 'picks the first matching candidate' do
      get '/users'

      expect(last_response.status).to eq(200)
      expect(last_response.content_type).to eq 'application/json'
      expect(last_response.body).to eq File.read('spec/fixtures/mocks/get-users.json')
    end
  end

  describe 'HTTP methods' do
    {
      get: 'get-multi.json',
      post: 'post-multi.json',
      put: 'put-multi.json',
      patch: 'patch-multi.json',
      delete: 'delete-multi.json',
      options: 'options-multi.json',
    }.each do |verb, fixture|
      it "serves #{verb.to_s.upcase} mocks" do
        send(verb, '/multi')

        expect(last_response.status).to eq(200)
        expect(last_response.content_type).to eq 'application/json'
        expect(last_response.body).to eq File.read("spec/fixtures/mocks/#{fixture}")
      end
    end
  end

  describe 'candidate variants' do
    it 'serves method-prefixed candidate for POST' do
      post '/candidate1'

      expect(last_response.status).to eq(200)
      expect(last_response.content_type).to eq 'application/json'
      expect(last_response.body).to eq File.read('spec/fixtures/mocks/post-candidate1.json')
    end

    it 'serves method file inside a folder for POST' do
      post '/candidate2'

      expect(last_response.status).to eq(200)
      expect(last_response.content_type).to eq 'application/json'
      expect(last_response.body).to eq File.read('spec/fixtures/mocks/candidate2/post.json')
    end

    it 'serves base file without method for POST' do
      post '/candidate3'

      expect(last_response.status).to eq(200)
      expect(last_response.content_type).to eq 'application/json'
      expect(last_response.body).to eq File.read('spec/fixtures/mocks/candidate3.json')
    end
  end
end
