class IPInfoService < DataService
    base_uri 'ipinfo.io'

    def get_data(current_data)
        response = Rails.cache.fetch("ipinfo/#{current_data[:ip_address]}", expires_in: 2.hours) do
            self.class.get("/#{current_data[:ip_address]}", {}).parsed_response
        end
        translate(current_data, response, {
            host_name: "hostname",
            ip_coords: "loc",
            internet_provider: "org",
            ip_area_code: "phone"
        })
    end

    def get_location(current_data)
        response = Rails.cache.fetch("ipinfo/#{current_data[:ip_address]}", expires_in: 2.hours) do
            self.class.get("/#{current_data[:ip_address]}", {}).parsed_response
        end
        current_data[:latitude] = response["loc"].split(",")[0].to_f
        current_data[:longitude] = response["loc"].split(",")[1].to_f
    end

end