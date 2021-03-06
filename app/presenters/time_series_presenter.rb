class TimeSeriesPresenter
  include Btspm::Presenters::Presentable

  class Scalar < Btspm::Presenters::ScalarPresenter
    def mortality_vs_recovery_chart_data
      return if _statistics_chart_data.blank?

      [_mortality_rate, _recovery_rate]
    end

    def time_series_chart_data
      return if _statistics_chart_data.blank?

      [
        { color: "#ffc107", data: _statistics_chart_data[:active], name: "Active" },
        { color: "#17a2b8", data: _statistics_chart_data[:confirmed], name: "Confirmed" },
        { color: "#dc3545", data: _statistics_chart_data[:deaths], name: "Deaths" },
        { color: "#28a745", data: _statistics_chart_data[:recovered], name: "Recoveries" }
      ]
    end

    private

    def _mortality_rate
      {
        color: "#dc3545",
        data: _statistics_chart_data[:mortality_rate],
        name: "Mortality Rate",
        tooltip: { valueSuffix: " %" },
        type: "column"
      }
    end

    def _recovery_rate
      {
        color: "#28a745",
        data: _statistics_chart_data[:recovery_rate],
        name: "Recovery Rate",
        tooltip: { valueSuffix: " %" },
        type: "column"
      }
    end

    def _statistics_chart_data
      @_statistics_chart_data ||= _stats&.chart_data
    end

    def _stats
      return if stats.blank?

      @_stats ||= StatsPresenter.present(stats, h)
    end
  end
end
