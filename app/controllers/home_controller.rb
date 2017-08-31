require 'data_service'
class HomeController < ApplicationController

    def index
        if has_geo_data?
            data = {}
            data[:latitude] = params[:lat]
            data[:longitude] = params[:long]
            data[:ip_address] = Rails.env.development? ? '47.185.52.238' : request.ip
            @service = DataService.new
            @service.setup
            @data = @service.get_data_from_services(data)
        else
            render 'get_geo_data'
        end
    end

    private
        def has_geo_data?
            params.key?(:lat) && params.key?(:long)
        end


end
