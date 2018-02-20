require 'data_service'
class HomeController < ApplicationController

    def index
        if has_geo_data?
            data = {}
            data[:latitude] = params[:lat]
            data[:longitude] = params[:long]
            data[:ip_address] = Rails.env.development? ? '207.62.170.213' : request.ip
            @service = DataService.new
            @service.setup
            @data = @service.get_data_from_services(data)
            p @data
        else
            render 'get_geo_data'
        end
    end

    def from_ip
        data = {}
        data[:ip_address] = Rails.env.development? ? '207.62.170.213' : request.ip
        @service = DataService.new
        @service.setup
        @service.fetch_lat_long(data)
        @data = @service.get_data_from_services(data)
        render 'index'
    end

    private
        def has_geo_data?
            params.key?(:lat) && params.key?(:long)
        end


end
