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

    private

    def _parse_response(response)
      body = response.body
      if body.is_a? Hash
        body.with_indifferent_access
      elsif body.is_a? Array
        body.map { |b| b.is_a?(Hash) ? b.with_indifferent_access : b }
      else
        body
      end
    end
  end
end
