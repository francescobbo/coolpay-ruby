describe Coolpay::Client do
  let(:subject) { Coolpay::Client.new('test', 'test_s3cr3t') }

  describe '#login' do
    context 'when the login is successful' do
      before do
        stub_request(:post, /\/login$/)
                    .to_return({
                      status: 200,
                      body: { token: 'helloworld' }.to_json,
                      headers: { 'Content-Type' => 'application/json' }
                    })
      end

      it 'responds with the authentication token' do
        expect(subject.login).to eq 'helloworld'
      end

      it 'saves the authentication token' do
        subject.login
        expect(subject.token).to eq 'helloworld'
      end
    end

    context 'when the login fails' do
      before do
        stub_request(:post, /\/login$/)
                .to_return({
                  status: 400,
                  body: { errors: 'Whoops' }.to_json
                })
      end

      it 'raises an exception' do
        expect {
          subject.login
        }.to raise_error Coolpay::Errors::InvalidCredentials
      end
    end
  end

  describe '#find_recipient' do
    context 'when the client is authenticated' do
      before { subject.token = '789-456-123' }

      it 'sends an authenticated request to the endpoint' do
        request = stub_request(:get, /recipients\?name=francesco/)
        subject.find_recipient('francesco')
        expect(request).to have_been_requested
      end
    end

    context 'when the client is not authenticated yet' do
      it 'authenticates for a token and does the request' do
        expect(subject).to receive(:login).and_return('456-123-789')

        request = stub_request(:get, /.+/).with(headers: { 'Authorization' => 'Bearer 456-123-789' })
        subject.find_recipient('francesco')

        expect(request).to have_been_requested
      end
    end

    it 'returns an array of matched recipients' do
      allow(subject).to receive(:login).and_return('456-123-789')

      matching = [ { 'name' => 'Francesco' }, { 'name' => 'Jason' } ]
      stub_request(:get, /recipients\?name=francesco/)
                    .to_return({
                      body: { recipients: matching }.to_json,
                      headers: { 'Content-Type' => 'application/json' }
                    })
      result = subject.find_recipient('francesco')

      expect(result).to eq matching
    end
  end
end
