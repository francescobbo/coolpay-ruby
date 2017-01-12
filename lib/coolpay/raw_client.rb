require 'faraday'
require 'json'

module Coolpay
  class RawClient
    def connection
      @connection ||= Faraday.new(url: 'https://coolpay.herokuapp.com')
    end

    def get(path, params = {}, token = nil)
      response = connection.get do |req|
        req.url "/api/#{path}", params
        req.headers['Authorization'] = "Bearer #{token}" if token
      end

      parse_response(response)
    end

    def post(path, body = {}, token = nil)
      response = connection.post do |req|
        req.url "/api/#{path}"
        req.headers['Content-Type'] = 'application/json'
        req.headers['Authorization'] = "Bearer #{token}" if token
        req.body = body.to_json
      end

      parse_response(response)
    end

    private

    def parse_response(response)
      if response.headers['Content-Type'] =~ %r{application/json}
        body = response.body.empty? ? {} : JSON.parse(response.body)
      else
        body = response.body
      end

      { status: response.status, body: body }
    end
  end
end
