class CoronaDataPresenter
  include Btspm::Presenters::Presentable

  class Scalar < Btspm::Presenters::ScalarPresenter
    def formatted_last_updated
      return "" if last_updated_at.blank?

      "Last Updated: #{h.time_ago_in_words last_updated_at}"
    end

    def stats
      @stats ||= StatsPresenter.present(data_object.stats, h)
    end

    def region_data
      @region_data ||= RegionsPresenter.present(data_object.region_data, h)
    end

    def map_data
      return unless region_data.country?

      region_data.global_map_data.merge(stats.map_data)
    end

  end

  class Enum < Btspm::Presenters::EnumPresenter
    def map_data
      map(&:map_data).compact.uniq
    end
  end
end
