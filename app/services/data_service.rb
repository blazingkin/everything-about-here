class DataService
    include HTTParty

    def setup
        @data_sources = [
            GoogleGeocodingService.new,
            OnWaterService.new,
            IPInfoService.new,
            IPSidekickService.new,
            CountryService.new,
            WeatherService.new,
            NASAService.new,
            ParkWhizService.new,
            GoogleMapEmbedService.new,
            GooglePlaceService.new,
            GoogleElevationService.new
        ]
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
        @data_sources.each do |service|
            begin
                current_data = service.get_data(current_data)
            rescue Exception => e
                # TODO log exception
                p e
                p e.backtrace
            end
        end
        current_data
    end

end