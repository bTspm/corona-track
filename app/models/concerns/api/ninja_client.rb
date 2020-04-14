module Api
  class NinjaClient < Client

    def latest_global_stats
      _fetch_cached("#{__method__}") { get("#{_base_url}/all") }
    end

    def global_time_series
      _fetch_cached("#{__method__}") { get("#{_base_url}/v2/historical?lastdays=all") }
    end

    def latest_countries_stats
      _fetch_cached("#{__method__}") { get("#{_base_url}/countries?sort=cases") }
    end

    def latest_country_stats_by_country_code(code)
      _fetch_cached("#{__method__}/#{code}") { get("#{_base_url}/countries/#{code}?strict=false") }
    end

    def country_time_series_by_country_code(code)
      _fetch_cached("#{__method__}/#{code}") { get("#{_base_url}/v2/historical/#{code}?lastdays=all") }
    end

    private

    def _fetch_cached(key, opts = {}, &block)
      opts[:expires_in] = 10.minutes
      Rails.cache.fetch(key, opts, &block)
    end

    def _base_url
      "https://corona.lmao.ninja"
    end
  end
end
