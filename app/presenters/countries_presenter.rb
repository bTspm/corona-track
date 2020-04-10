class CountriesPresenter
  include Btspm::Presenters::Presentable

  class Scalar < Btspm::Presenters::ScalarPresenter
    def map_data
      {
        code3: alpha3,
        code: alpha2,
        name: name.gsub(/'/, ""),
        value: total_confirmed
      }.with_indifferent_access
    end

    def mortality_rate
      value = (total_deaths / total_confirmed.to_f) * 100
      h.number_to_percentage(value, precision: 2)
    end

    def name_with_flag
      return name if alpha2.blank?

      (h.flag(alpha2) + " #{name}").html_safe
    end

    def new_cases
      value = total_confirmed - _previous_day_stats.confirmed
      "+#{h.number_with_delimiter value}"
    end

    def new_deaths
      value = total_deaths - _previous_day_stats.deaths
      "+#{h.number_with_delimiter value}"
    end

    def new_recovered
      value = total_recovered - _previous_day_stats.recovered
      "+#{h.number_with_delimiter value}"
    end

    def readable_total_active
      h.number_with_delimiter total_active
    end

    def readable_total_confirmed
      h.number_with_delimiter total_confirmed
    end

    def readable_total_deaths
      h.number_with_delimiter total_deaths
    end

    def readable_mortality_rate
      h.number_to_percentage(mortality_rate, precision: 2)
    end

    def readable_total_recovered
      h.number_with_delimiter total_recovered
    end

    def recovery_rate
      value = (total_recovered / total_confirmed.to_f) * 100
      h.number_to_percentage(value, precision: 2)
    end

    private

    def _previous_day_stats
      @_previous_day_stats ||= _stats_sorted_by_date_asc[-2]
    end

    def _stats_sorted_by_date_asc
      @_stats_sorted_by_date_asc ||= stats.sort_by(&:date)
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
      @chart_data ||= {
        confirmed: _transposed_chart_data[CONFIRMED_INDEX],
        recovered: _transposed_chart_data[RECOVERED_INDEX],
        deaths: _transposed_chart_data[DEATHS_INDEX],
        active: _transposed_chart_data[ACTIVE_INDEX],
        mortality_rate: _transposed_chart_data[MORTALITY_RATE_INDEX],
        recovery_rate: _transposed_chart_data[RECOVERY_RATE_INDEX]
      }
    end

    def comparisons_chart_data
      [_time_series_mortality_rate, _time_series_recovery_rate]
    end

    def for_select
      reject(&:not_country?).sort_by { |country| country.name.downcase }
    end

    def counts_chart_data
      [
        { color: "#ffc107", data: chart_data[:active], name: "Active" },
        { color: "#17a2b8", data: chart_data[:confirmed], name: "Confirmed" },
        { color: "#dc3545", data: chart_data[:deaths], name: "Deaths" },
        { color: "#28a745", data: chart_data[:recovered], name: "Recoveries" },
      ]
    end

    def map_data
      map(&:map_data).compact.uniq
    end

    def mortality_rate
      value = (_total_deaths / _total_confirmed.to_f) * 100
      h.number_to_percentage(value, precision: 2)
    end

    def readable_total_active
      h.number_with_delimiter _total_active
    end

    def readable_total_confirmed
      h.number_with_delimiter _total_confirmed
    end

    def readable_total_deaths
      h.number_with_delimiter _total_deaths
    end

    def readable_total_recovered
      h.number_with_delimiter _total_recovered
    end

    def recovery_rate
      value = (_total_recovered / _total_confirmed.to_f) * 100
      h.number_to_percentage(value, precision: 2)
    end

    private

    def _all_stats
      @_all_stats ||= map(&:stats).flatten.group_by(&:date)
    end

    def _time_series_mortality_rate
      {
        color: "#dc3545",
        data: chart_data[:mortality_rate],
        name: "Mortality Rate",
        tooltip: { valueSuffix: " %" },
        type: "column",
      }
    end

    def _time_series_recovery_rate
      {
        color: "#28a745",
        data: chart_data[:recovery_rate],
        name: "Recovery Rate",
        tooltip: { valueSuffix: " %" },
        type: "column",
      }
    end

    def _total_active
      @_total_active ||= sum(&:total_active)
    end

    def _total_confirmed
      @_total_confirmed ||= sum(&:total_confirmed)
    end

    def _total_deaths
      @_total_deaths ||= sum(&:total_deaths)
    end

    def _total_recovered
      @_total_recovered ||= sum(&:total_recovered)
    end

    def _transposed_chart_data
      @_transposed_chart_data ||= _all_stats.map do |date, stats|
        date_formatted = date.to_datetime.to_i * 1000
        confirmed = stats.sum(&:confirmed)
        recovered = stats.sum(&:recovered)
        deaths = stats.sum(&:deaths)
        active = confirmed - (recovered + deaths)
        [
          [date_formatted, confirmed],
          [date_formatted, recovered],
          [date_formatted, deaths],
          [date_formatted, active],
          [date_formatted, ((deaths / confirmed.to_f) * 100).round(2)], # Mortality Rate
          [date_formatted, ((recovered / confirmed.to_f) * 100).round(2)] # Recovery Rate
        ]
      end.transpose
    end
  end
end
