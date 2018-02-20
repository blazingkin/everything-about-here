class DataService
    include HTTParty

    def setup
        @data_sources = [
            FccFipsService.new,
            GoogleGeocodingService.new,
            OnWaterService.new,
            IPInfoService.new,
            IPSidekickService.new,
            CountryService.new,
            WeatherService.new,
            NASAService.new,
            #ParkWhizService.new,
            GoogleMapEmbedService.new,
            GooglePlaceService.new,
            GoogleElevationService.new,
            BroadbandMapService.new,
            DemographicsService.new,
            LanguageService.new
        ]
    end

    def fetch_lat_long(current_data)
        IPInfoService.new.get_location(current_data)
    end

    def get_data(current_data)
        current_data
    end

    def translate(current_data, from_service, translation_hash)
        translation_hash.each do |translated_key, service_key|
            current_data[translated_key] ||= from_service[service_key]
        end
        current_data
    end

    def get_data_from_services(current_data)
        current_data[:short_lat] = current_data[:latitude]&.to_f&.round(3)
        current_data[:short_lon] = current_data[:longitude]&.to_f&.round(3)
        current_data[:successful_services] = []
        @data_sources.each do |service|
            begin
                current_data = service.get_data(current_data)
                current_data[:successful_services] << service.class
            rescue Exception => e
                # TODO log exception
                p e
                p e.backtrace
		Rails.logger.debug(e)
		Rails.logger.debug(e.backtrace)
            end
        end
        current_data
    end

end
