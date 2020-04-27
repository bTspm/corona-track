class CoronaController < ApplicationController
  def countries_list
    countries = present(_service.countries_list, RegionsPresenter)
    render partial: 'countries_dropdown', locals: { countries: countries, selected: params[:code] }
  end

  def countries_stats
    countries_corona_data = present(_service.latest_countries_stats, CoronaDataPresenter)
    render partial: 'country_details', locals: { countries_corona_data: countries_corona_data }
  end

  def country_time_series
    time_series = present(_service.country_time_series_by_country_code(params[:code]), TimeSeriesPresenter)
    render partial: 'time_series', locals: { time_series: time_series }
  end

  def country
    @corona_data = present(_service.latest_country_stats_by_country_code(params[:code]), CoronaDataPresenter)
  end

  def global_time_series
    time_series = present(_service.global_time_series, TimeSeriesPresenter)
    render partial: 'time_series', locals: { time_series: time_series }
  end

  def home
    @corona_data = present(_service.latest_global_stats, CoronaDataPresenter)
  end

  def state_stats
    state_corona_data = present(
      _service.latest_state_stats_by_country_code(params[:country_code]),
      CoronaDataPresenter
    )
    render partial: 'state_details', locals: { state_corona_data: state_corona_data }
  end

  private

  def _service
    @_service ||= CoronaService.new
  end
end
