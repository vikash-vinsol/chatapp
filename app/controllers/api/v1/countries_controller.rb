module Api
  module V1
    class CountriesController < BaseController
      skip_before_filter :authorize_request

      def index
        @countries = Country.where(true)
      end
    end
  end
end