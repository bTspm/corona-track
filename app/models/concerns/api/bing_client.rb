module Api
  class BingClient < Client

    def country_stats
      fetch_cached("#{self.class.name}/#{__method__}") { get _base_url }
    end

    private

    def _base_url
      "https://bing.com/covid/data"
    end
  end
end
