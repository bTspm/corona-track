module Api
  class Client
    include ::Cacheable

    def initialize
      @conn = Faraday.new do |conn|
        conn.request :json
        conn.request :url_encoded
        conn.response :json
        conn.response :logger
        conn.adapter Faraday.default_adapter
      end
    end

    def get(url)
      _parse_response(@conn.get(url))
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
      @body = _build_body(response)
      @headers = response.headers
      @status = response.status
      @success = response.success?
    end

    private

    def _build_body(response)
      body = response.body
      if body.is_a? Hash
        body.with_indifferent_access
      elsif body.is_a? Array
        body.map(&:with_indifferent_access)
      else
        body
      end
    end
  end
end
