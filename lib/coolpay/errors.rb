module Coolpay
  module Errors
    class InvalidCredentials < StandardError
    end

    class ApiError < StandardError
      attr_reader :status, :body

      def initialize(response)
        super("API responded with unexpected status #{response[:status]}.")

        @status = response[:status]
        @body = response[:body]
      end
    end
  end
end
