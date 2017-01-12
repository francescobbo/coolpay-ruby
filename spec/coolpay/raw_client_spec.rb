describe Coolpay::RawClient do
  describe '#post' do
    it 'sends a POST request to the API server' do
      request = stub_request(:post, 'https://coolpay.herokuapp.com/api/login')
      subject.post('login')
      expect(request).to have_been_requested
    end

    it 'sets the Content-Type header to JSON' do
      request = stub_request(:any, /.*/).with(headers: { 'Content-Type' => 'application/json' })
      subject.post('login')
      expect(request).to have_been_requested
    end

    it 'encodes the params as JSON' do
      request = stub_request(:any, /.*/).with(body: '{"username":"francesco"}')
      subject.post('login', { username: 'francesco' })
      expect(request).to have_been_requested
    end
  end
end
