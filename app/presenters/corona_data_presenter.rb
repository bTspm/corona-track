class CoronaDataPresenter
  include Btspm::Presenters::Presentable

  class Scalar < Btspm::Presenters::ScalarPresenter
    def formatted_last_updated
      return "" if last_updated_at.blank?

      "Last Updated: #{h.time_ago_in_words last_updated_at}"
    end

    def stats
      StatsPresenter.present(data_object.stats, h)
    end

    def region_data
      RegionsPresenter.present(data_object.region_data, h)
    end

  end

  class Enum < Btspm::Presenters::EnumPresenter
  end
end
