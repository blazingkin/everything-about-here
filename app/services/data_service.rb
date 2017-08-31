class DataService
    include HTTParty

    def get_data(current_data)
        current_data
    end

    def translate(current_data, from_service, translation_hash)
        translation_hash.each do |translated_key, service_key|
            current_data[translated_key] = from_service[service_key]
        end
        current_data
    end

    def self.get_data_from_services(current_data)
        current_data = OnWaterService.new.get_data(current_data)
        current_data = IPInfoService.new.get_data(current_data)
        current_data = IPSidekickService.new.get_data(current_data)
        current_data = CountryService.new.get_data(current_data)
        current_data = WeatherService.new.get_data(current_data)
        current_data = NASAService.new.get_data(current_data)
    end

end