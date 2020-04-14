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

  end

  class Enum < Btspm::Presenters::EnumPresenter
    def map_data
      map(&:map_data).compact.uniq
    end
  end
end
