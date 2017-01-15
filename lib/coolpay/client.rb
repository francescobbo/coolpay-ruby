module Coolpay
  class Client
    attr_writer :username, :apikey
    attr_accessor :token

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
      auth_token = token || login

      response = raw_client.get 'recipients', { name: name }, auth_token
      response[:body]['recipients']
    end

    def create_recipient(name)
      auth_token = token || login

      response = raw_client.post 'recipients', { recipient: { name: name } }, auth_token
      raise Errors::ApiError.new(response) unless response[:status] == 201

      response[:body]['recipient']
    end

    def list_payments
      auth_token = token || login

      response = raw_client.get 'payments', { }, auth_token
      response[:body]['payments']
    end

    def create_payment(amount, currency, recipient_id)
      auth_token = token || login

      response = raw_client.post('payments', {
        payment: {
          amount: amount,
          currency: currency,
          recipient_id: recipient_id
        }
      }, auth_token)

      raise Errors::ApiError.new(response) unless response[:status] == 201

      response[:body]['payment']
    end

    private

    def raw_client
      @raw_client ||= RawClient.new
    end
  end
end
