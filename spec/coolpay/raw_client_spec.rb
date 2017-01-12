describe Coolpay::RawClient do
  describe '#get' do
    it 'sends a GET request to the API server' do
      request = stub_request(:get, 'https://coolpay.herokuapp.com/api/recipients')
      subject.get('recipients')
      expect(request).to have_been_requested
    end

    it 'sets the query string using the params' do
      request = stub_request(:get, 'https://coolpay.herokuapp.com/api/recipients?name=francesco')
      subject.get('recipients', name: 'francesco')
      expect(request).to have_been_requested
    end

    it 'uses the optional token as an "Authorization Bearer" token' do
      request = stub_request(:get, 'https://coolpay.herokuapp.com/api/recipients')
                .with(headers: { 'Authorization' => 'Bearer 123-456-789' })
      subject.get('recipients', {}, '123-456-789')
      expect(request).to have_been_requested
    end

    it 'responds with the status and parsed JSON body' do
      stub_request(:get, /.*/).to_return(status: 200,
                                         body: '{"name":"francesco"}',
                                         headers: { 'Content-Type' => 'application/json' })

      response = subject.get('recipients')
      expect(response).to eq(status: 200, body: { 'name' => 'francesco' })
    end
  end

  describe '#post' do
    it 'sends a POST request to the API server' do
      request = stub_request(:post, 'https://coolpay.herokuapp.com/api/login')
      subject.post('login')
      expect(request).to have_been_requested
    end

    it 'sets the Content-Type header to JSON' do
      request = stub_request(:post, /.*/).with(headers: { 'Content-Type' => 'application/json' })
      subject.post('login')
      expect(request).to have_been_requested
    end

    it 'encodes the params as JSON' do
      request = stub_request(:post, /.*/).with(body: '{"username":"francesco"}')
      subject.post('login', username: 'francesco')
      expect(request).to have_been_requested
    end

    it 'uses the optional token as an "Authorization Bearer" token' do
      request = stub_request(:post, 'https://coolpay.herokuapp.com/api/recipients')
                .with(headers: { 'Authorization' => 'Bearer 123-456-789' })
      subject.post('recipients', {}, '123-456-789')
      expect(request).to have_been_requested
    end

    it 'responds with the status and parsed JSON body' do
      stub_request(:post, /.*/).to_return(status: 200,
                                          body: '{"token":"0123456789abcdef"}',
                                          headers: { 'Content-Type' => 'application/json' })

      response = subject.post('login')
      expect(response).to eq(status: 200, body: { 'token' => '0123456789abcdef' })
    end
  end
end
