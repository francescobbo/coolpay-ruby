require 'faraday'
require 'json'

module Coolpay
  class RawClient
    def connection
      @connection ||= Faraday.new(url: 'https://coolpay.herokuapp.com')
    end

    def post(path, body = {})
      response = connection.post do |req|
        req.url "/api/#{path}"
        req.headers['Content-Type'] = 'application/json'
        req.body = body.to_json
      end

      parse_response(response)
    end

    private

    def parse_response(response)
      if response.headers['Content-Type'] =~ /application\/json/
        body = response.body.empty? ? {} : JSON.parse(response.body)
      else
        body = response.body
      end

      { status: response.status, body: body }
    end
  end
end
