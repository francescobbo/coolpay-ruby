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
end
