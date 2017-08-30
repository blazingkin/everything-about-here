class DataService

    def self.get_data(current_data)
        current_data
    end

    def self.get_data_from_services(current_data)
        OnWaterService.new.get_data(current_data)
    end

end