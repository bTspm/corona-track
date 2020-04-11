class StatsPresenter
  include Btspm::Presenters::Presentable

  class Scalar < Btspm::Presenters::ScalarPresenter
    def chart_formatted_date
      @chart_formatted_date ||= datetime.to_datetime.to_i * 1000
    end

    def map_data
      {
        active: h.number_with_delimiter(active),
        confirmed: readable_confirmed,
        deaths: readable_deaths,
        recovered: readable_recovered,
        value: confirmed
      }
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

    def time_series_chart_data
      [
        [chart_formatted_date, confirmed],
        [chart_formatted_date, recovered],
        [chart_formatted_date, deaths],
        [chart_formatted_date, active],
        [chart_formatted_date, mortality_rate],
        [chart_formatted_date, recovery_rate]
      ]
    end
  end

  class Enum < Btspm::Presenters::EnumPresenter
    CONFIRMED_INDEX = 0
    RECOVERED_INDEX = 1
    DEATHS_INDEX = 2
    ACTIVE_INDEX = 3
    MORTALITY_RATE_INDEX = 4
    RECOVERY_RATE_INDEX = 5

    def chart_data
      {
        confirmed: _transposed_chart_data[CONFIRMED_INDEX],
        recovered: _transposed_chart_data[RECOVERED_INDEX],
        deaths: _transposed_chart_data[DEATHS_INDEX],
        active: _transposed_chart_data[ACTIVE_INDEX],
        mortality_rate: _transposed_chart_data[MORTALITY_RATE_INDEX],
        recovery_rate: _transposed_chart_data[RECOVERY_RATE_INDEX]
      }
    end

    private

    def _transposed_chart_data
      @_transposed_chart_data ||= map(&:time_series_chart_data).transpose
    end
  end
end
