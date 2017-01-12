require 'faraday'
require 'json'

module Coolpay
  class RawClient
    def connection
      @connection ||= Faraday.new(url: 'https://coolpay.herokuapp.com')
    end

    def post(path, params = {})
      connection.post do |req|
        req.url "/api/#{path}"
        req.headers['Content-Type'] = 'application/json'
        req.body = params.to_json
      end
    end
  end
end
