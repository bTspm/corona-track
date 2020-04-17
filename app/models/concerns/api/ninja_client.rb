module Api
  class NinjaClient < Client

    def latest_global_stats
      fetch_cached("#{self.class.name}/#{__method__}") { get("#{_base_url}/#{_version}/all") }
    end

    def global_time_series
      fetch_cached("#{self.class.name}/#{__method__}") { get("#{_base_url}/#{_version}/historical?lastdays=all") }
    end

    def latest_countries_stats
      fetch_cached("#{self.class.name}/#{__method__}") { get("#{_base_url}/#{_version}/countries?sort=cases") }
    end

    def latest_country_stats_by_country_code(code)
      fetch_cached("#{self.class.name}/#{__method__}/#{code}") { get("#{_base_url}/#{_version}/countries/#{code}?strict=false") }
    end

    def country_time_series_by_country_code(code)
      fetch_cached("#{self.class.name}/#{__method__}/#{code}") { get("#{_base_url}/#{_version}/historical/#{code}?lastdays=all") }
    end

    private

    def _base_url
      "https://corona.lmao.ninja"
    end

    def _version
      ENV["NINJA_VERSION"] || "v2"
    end
  end
end
