class StatsPresenter
  include Btspm::Presenters::Presentable

  class Scalar < Btspm::Presenters::ScalarPresenter
    def readable_active
      h.number_with_delimiter active
    end

    def readable_confirmed
      h.number_with_delimiter confirmed
    end

    def readable_critical
      h.number_with_delimiter critical
    end

    def readable_deaths
      h.number_with_delimiter deaths
    end

    def readable_mortality_rate
      return "N/A" if deaths.blank? || confirmed.blank?

      value = (deaths / confirmed.to_f) * 100
      h.number_to_percentage(value, precision: 2)
    end

    def readable_new_confirmed
      "+#{h.number_with_delimiter new_confirmed}"
    end

    def readable_new_deaths
      "+#{h.number_with_delimiter new_deaths}"
    end

    def readable_recovered
      h.number_with_delimiter recovered
    end

    def readable_tests
      h.number_with_delimiter tests
    end

    def pie_chart_data
      data = [
        { color: "#ffc107", name: "Active", y: active },
        { color: "#dc3545", name: "Deaths", y: deaths },
        { color: "#28a745", name: "Recovered", y: recovered }
      ]
      [{ name: "Cases", colorByPoint: true, data: data }]
    end
  end

  class Enum < Btspm::Presenters::EnumPresenter
  end
end
