class CoronaController < ApplicationController

  # def global_time_series_stats_path
  #   # time_series = present(stock_service.news_by_symbol(params[:symbol]), TimeSeriesPresenter)
  #   # render partial: 'stocks/information_v2/news', locals: { news: news }
  # end

  def country
    redirect_to root_path if params[:code].blank?
    @countries = present(CoronaService.new.countries, CountriesPresenter)
    _country_by_code
  end

  def home
    @corona_data = present(_service.global_latest_stats, CoronaDataPresenter)
    @countries = present(CoronaService.new.countries, CountriesPresenter)
  end

  def countries_stats
    corona_data = present(_service.latest_countries_stats, CoronaDataPresenter)
    render partial: 'country_details', locals: { corona_data: corona_data }
  end

  private

  def _country_by_code
    country = CoronaService.new.country_by_code(
      code: params[:code]&.upcase,
      countries: @countries
    )
    @country = present([country], CountriesPresenter)
  end

  def _service
    @_service ||= CoronaService.new
  end
end
