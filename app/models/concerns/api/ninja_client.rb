module Api
  class NinjaClient < Client

    def latest_global_stats
      get("#{_base_url}/all")
    end

    def global_time_series
      get("#{_base_url}/v2/historical?lastdays=all")
    end

    def latest_countries_stats
      get("#{_base_url}/countries?sort=cases")
    end

    def latest_country_counts_by_code

    end

    private

    def _base_url
      "https://corona.lmao.ninja"
    end
  end
end
