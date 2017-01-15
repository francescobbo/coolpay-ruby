module Coolpay
  class Client
    attr_writer :username, :apikey
    attr_writer :token

    def initialize(username = nil, apikey = nil)
      self.username = username
      self.apikey = apikey
    end

    def login
      response = raw_client.post 'login', username: @username, apikey: @apikey
      raise Errors::InvalidCredentials unless response[:status] == 200

      self.token = response[:body]['token']
    end

    def find_recipient(name)
      response = raw_client.get 'recipients', { name: name }, token
      response[:body]['recipients']
    end

    def create_recipient(name)
      response = raw_client.post 'recipients', { recipient: { name: name } }, token
      raise Errors::ApiError.new(response) unless response[:status] == 201

      response[:body]['recipient']
    end

    def list_payments
      response = raw_client.get 'payments', {}, token
      response[:body]['payments']
    end

    def create_payment(amount, currency, recipient_id)
      payment = {
        payment: {
          amount: amount,
          currency: currency,
          recipient_id: recipient_id
        }
      }

      response = raw_client.post('payments', payment, token)
      raise Errors::ApiError.new(response) unless response[:status] == 201

      response[:body]['payment']
    end

    def token
      @token ||= login
    end

    private

    def raw_client
      @raw_client ||= RawClient.new
    end
  end
end
