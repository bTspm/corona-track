class CoronaDataPresenter
  include Btspm::Presenters::Presentable

  class Scalar < Btspm::Presenters::ScalarPresenter
    def stats
      @stats ||= StatsPresenter.present(data_object.stats, h)
    end

    def region_data
      @region_data ||= RegionsPresenter.present(data_object.region_data, h)
    end

    def map_data
      return unless region_data.country?

      region_data.map_data_for_country.merge(stats.map_data)
    end

    def map_data_for_state_or_province
      region_data.map_data_for_state_or_province.merge(stats.map_data_for_state_or_province)
    end
  end

  class Enum < Btspm::Presenters::EnumPresenter
    def map_data
      map(&:map_data).compact.uniq
    end

    def map_data_for_state_or_province
      {
        data: map(&:map_data_for_state_or_province).compact.uniq,
        map_name: _map_name
      }
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
