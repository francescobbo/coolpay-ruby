module Coolpay
  class Client
    attr_writer :username, :apikey
    attr_accessor :token

    def initialize(username = nil, apikey = nil)
      self.username = username
      self.apikey = apikey
    end

    def login
      response = raw_client.post 'login', { username: @username, apikey: @apikey }
      raise Errors::InvalidCredentials unless response[:status] == 200

      self.token = response[:body]['token']
    end

    private

    def raw_client
      @raw_client ||= RawClient.new
    end
  end
end