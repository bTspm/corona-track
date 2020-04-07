class CoronaController < ApplicationController
  def country
    @country = CoronaService.new.country_by_code(params[:country_code])
  end

  def home
    @countries = present(CoronaService.new.countries, CountriesPresenter)
  end
end
