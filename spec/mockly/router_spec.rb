require 'json'

describe Mockly::Router do
  subject(:router) { described_class.new(mock_root: mock_root) }

  let(:mock_root) { File.expand_path('../fixtures/mocks', __dir__) }

  describe '#resolve' do
    it 'picks the first matching candidate' do
      body = router.resolve(req_path: 'users', method: 'GET', request_path: '/users')
      expect(body).to eq(File.read('spec/fixtures/mocks/get-users.json'))
    end

    {
      get:     'get-multi.json',
      post:    'post-multi.json',
      put:     'put-multi.json',
      patch:   'patch-multi.json',
      delete:  'delete-multi.json',
      options: 'options-multi.json',
    }.each do |verb, fixture|
      it "resolves #{verb.to_s.upcase} mocks" do
        body = router.resolve(
          req_path:     'multi',
          method:       verb.to_s.upcase,
          request_path: '/multi'
        )

        expect(body).to eq(File.read("spec/fixtures/mocks/#{fixture}"))
      end
    end

    it 'resolves method-prefixed candidate for POST' do
      body = router.resolve(req_path: 'candidate1', method: 'POST', request_path: '/candidate1')
      expect(body).to eq(File.read('spec/fixtures/mocks/post-candidate1.json'))
    end

    it 'resolves method file inside a folder for POST' do
      body = router.resolve(req_path: 'candidate2', method: 'POST', request_path: '/candidate2')
      expect(body).to eq(File.read('spec/fixtures/mocks/candidate2/post.json'))
    end

    it 'resolves base file without method for POST' do
      body = router.resolve(req_path: 'candidate3', method: 'POST', request_path: '/candidate3')
      expect(body).to eq(File.read('spec/fixtures/mocks/candidate3.json'))
    end

    it 'resolves a YAML GET route when no file route exists' do
      body = router.resolve(req_path: 'yaml-object', method: 'GET', request_path: '/yaml-object')
      expect(body).to eq({ status: 'ok' }.to_json)
    end

    it 'resolves a YAML POST route when no file route exists' do
      body = router.resolve(req_path: 'yaml-post', method: 'POST', request_path: '/yaml-post')
      expect(body).to eq({ created: true }.to_json)
    end

    it 'resolves YAML routes with normalized trailing slash' do
      body = router.resolve(req_path: 'slash', method: 'GET', request_path: '/slash/')
      expect(body).to eq({ path: 'normalized' }.to_json)
    end

    it 'returns JSON for YAML scalar values' do
      body = router.resolve(req_path: 'yaml-scalar', method: 'GET', request_path: '/yaml-scalar')
      expect(body).to eq('hello'.to_json)
    end

    it 'returns nil when no file or YAML route matches' do
      body = router.resolve(req_path: 'missing', method: 'GET', request_path: '/missing')
      expect(body).to be_nil
    end

    context 'with invalid YAML' do
      let(:mock_root) { File.expand_path('../fixtures/mocks-broken', __dir__) }

      it 'returns nil' do
        body = router.resolve(req_path: 'broken', method: 'GET', request_path: '/broken')
        expect(body).to be_nil
      end
    end
  end
end
