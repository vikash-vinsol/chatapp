class CountriesController < ApplicationController
  def index
    @countries = Country.where(true)
  end
end