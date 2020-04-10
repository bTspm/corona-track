class TimeSeriesPresenter
  include Btspm::Presenters::Presentable

  class Scalar < Btspm::Presenters::ScalarPresenter

    def formatted_values
      counts.map do |day, count|
        [day.to_i * 1_000, count]
      end
    end
  end

  class Enum < Btspm::Presenters::EnumPresenter
    def chart_data
      [_confirmed, _deaths, _recovered]
    end

    private

    def _confirmed
      {
        color: "#17a2b8",
        data: detect(&:confirmed?).formatted_values,
        name: "Confirmed"
      }
    end

    def _deaths
      {
        color: "#dc3545",
        data: detect(&:deaths?).formatted_values,
        name: "Deaths"
      }
    end

    def _recovered
      {
        color: "#28a745",
        data: detect(&:recovered?).formatted_values,
        name: "Recoveries"
      }
    end
  end
end
