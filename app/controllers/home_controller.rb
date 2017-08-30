require 'data_service'
class HomeController < ApplicationController

    def index
        if has_geo_data?
            data = {}
            data[:latitude] = params[:lat]
            data[:longitude] = params[:long]
            data[:ip_address] = request.ip
            @data = DataService.get_data_from_services(data)
        else
            render 'get_geo_data'
        end
    end

    private
        def has_geo_data?
            params.key?(:lat) && params.key?(:long)
        end


end
