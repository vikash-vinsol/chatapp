module Api
  module V1
    class CountriesController < BaseController
      def index
        @countries = Country.where(true)
      end
    end
  end
end