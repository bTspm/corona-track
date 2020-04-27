class CoronaDataPresenter
  include Btspm::Presenters::Presentable

  class Scalar < Btspm::Presenters::ScalarPresenter
    def map_data_for_state
      region_data.map_data_for_state.merge(stats.map_data_for_state)
    end

    def map_data
      return unless region_data.country?

      region_data.map_data_for_country.merge(stats.map_data)
    end

    def region_data
      @region_data ||= RegionsPresenter.present(data_object.region_data, h)
    end

    def stats
      @stats ||= StatsPresenter.present(data_object.stats, h)
    end
  end

  class Enum < Btspm::Presenters::EnumPresenter
    def map_data_for_state
      {
        data: map(&:map_data_for_state).compact,
        map_name: _map_name
      }
    end

    def map_data
      map(&:map_data).compact
    end

    private

    def _map_name
      country = first.region_data.parent
      return "countries/in/custom/in-all-disputed" if country.india?

      code = country.alpha2.downcase
      "countries/#{code}/#{code}-all"
    end
  end
end
