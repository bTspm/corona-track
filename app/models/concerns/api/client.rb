module Api
  class Client
    def initialize
      @conn =
        Faraday.new do |conn|
          conn.request :json
          conn.request :url_encoded
          conn.response :json
          conn.response :logger
          conn.adapter Faraday.default_adapter
        end
    end

    def get
      _parse_response(@conn.get("https://pomber.github.io/covid19/timeseries.json"))
    end

    protected

    def _parse_response(response)
      Api::Response.new(response)
    end
  end

  class Response
    attr_reader :body,
                :headers,
                :status,
                :success

    def initialize(response)
      @body = response.body.with_indifferent_access
      @headers = response.headers
      @status = response.status
      @success = response.success?
    end
  end
end
