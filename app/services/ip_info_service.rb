class IPInfoService < DataService
    base_uri 'ipinfo.io'

    def get_data(current_data)
        response = Rails.cache.fetch("ipinfo/#{current_data[:ip_address]}", :expires => 2.hours) do
            self.class.get("/#{current_data[:ip_address]}", {}).parsed_response
        end
        translate(current_data, response, {
            host_name: "hostname",
            ip_coords: "loc",
            internet_provider: "org",
            ip_area_code: "phone"
        })
    end

end