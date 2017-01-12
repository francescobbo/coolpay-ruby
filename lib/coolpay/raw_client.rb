require 'faraday'
require 'json'

module Coolpay
  class RawClient
    def connection
      @connection ||= Faraday.new(url: 'https://coolpay.herokuapp.com')
    end

    def post(path, body = {})
      connection.post do |req|
        req.url "/api/#{path}"
        req.headers['Content-Type'] = 'application/json'
        req.body = body.to_json
      end
    end
  end
end
