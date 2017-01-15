describe Coolpay::Client do
  let(:subject) { Coolpay::Client.new('test', 'test_s3cr3t') }

  describe '#login' do
    context 'when the login is successful' do
      before do
        stub_request(:post, %r{/login$})
          .to_return(status: 200,
                     body: { token: 'helloworld' }.to_json,
                     headers: { 'Content-Type' => 'application/json' })
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
        stub_request(:post, %r{/login$})
          .to_return(status: 400,
                     body: { errors: 'Whoops' }.to_json)
      end

      it 'raises an exception' do
        expect do
          subject.login
        end.to raise_error Coolpay::Errors::InvalidCredentials
      end
    end
  end

  context 'when the client is authenticated' do
    before { subject.token = '789-456-123' }

    describe '#find_recipient' do
      it 'sends an authenticated request to the endpoint' do
        request = stub_request(:get, /recipients\?name=francesco/)
        subject.find_recipient('francesco')
        expect(request).to have_been_requested
      end

      it 'returns an array of matched recipients' do
        allow(subject).to receive(:login).and_return('456-123-789')

        matching = [{ 'name' => 'Francesco' }, { 'name' => 'Jason' }]
        stub_request(:get, /recipients\?name=francesco/)
          .to_return(body: { recipients: matching }.to_json,
                     headers: { 'Content-Type' => 'application/json' })
        result = subject.find_recipient('francesco')

        expect(result).to eq matching
      end
    end

    describe '#create_recipient' do
      it 'sends an authenticated request to the endpoint' do
        request = stub_request(:post, /recipients$/)
                  .to_return(status: 201)
        subject.create_recipient('francesco')
        expect(request).to have_been_requested
      end

      it 'returns the created recipient' do
        allow(subject).to receive(:login).and_return('456-123-789')

        data = { 'recipient' => { 'name' => 'francesco' } }
        stub_request(:post, /recipients$/)
          .to_return(status: 201,
                     body: data.to_json,
                     headers: { 'Content-Type' => 'application/json' })
        result = subject.create_recipient('francesco')

        expect(result).to eq data['recipient']
      end
    end

    describe '#list_payments' do
      it 'sends an authenticated request to the endpoint' do
        request = stub_request(:get, /payments/)
        subject.list_payments
        expect(request).to have_been_requested
      end

      it 'returns an array of payments' do
        allow(subject).to receive(:login).and_return('456-123-789')

        list = [{ 'amount' => 50 }, { 'amount' => 100 }]
        stub_request(:get, /payments/)
          .to_return(body: { payments: list }.to_json,
                     headers: { 'Content-Type' => 'application/json' })
        result = subject.list_payments

        expect(result).to eq list
      end
    end

    describe '#create_payment' do
      it 'sends an authenticated request to the endpoint' do
        request = stub_request(:post, /payments$/)
                  .to_return(status: 201)
        subject.create_payment(100, 'GBP', '123')
        expect(request).to have_been_requested
      end

      it 'returns the created recipient' do
        data = { 'recipient' => { 'amount' => 100, 'currency' => 'GBP', 'recipient_id' => '123' } }
        stub_request(:post, /payments$/)
          .to_return(status: 201,
                     body: data.to_json,
                     headers: { 'Content-Type' => 'application/json' })
        result = subject.create_payment(100, 'GBP', '123')

        expect(result).to eq data['payment']
      end
    end
  end

  context 'when the client is not authenticated' do
    before { expect(subject).to receive(:login) }

    describe '#find_recipient' do
      it 'performs authentication' do
        stub_request(:any, /.+/)
        subject.find_recipient('francesco')
      end
    end

    describe '#create_recipient' do
      it 'performs authentication' do
        stub_request(:any, /.+/).to_return(status: 201)
        subject.create_recipient('francesco')
      end
    end

    describe '#list_payments' do
      it 'performs authentication' do
        stub_request(:any, /.+/).to_return(status: 201)
        subject.list_payments
      end
    end

    describe '#create_payment' do
      it 'performs authentication' do
        stub_request(:any, /.+/).to_return(status: 201)
        subject.create_payment(2000, 'EUR', 'me')
      end
    end
  end
end
