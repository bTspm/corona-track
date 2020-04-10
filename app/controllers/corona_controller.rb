class CoronaController < ApplicationController
  def global_time_series
    time_series = present(_service.global_time_series, TimeSeriesPresenter)
    render partial: 'time_series', locals: { chart_data: time_series.chart_data }
    # render partial: 'country_details', locals: { corona_data: corona_data }
  end

  def home
    @corona_data = present(_service.latest_global_stats, CoronaDataPresenter)
  end

  def countries_stats
    data = present(_service.latest_countries_stats, CoronaDataPresenter)
    render partial: 'countries_table', locals: { data: data }
  end

  private

  def _service
    @_service ||= CoronaService.new
  end
end
