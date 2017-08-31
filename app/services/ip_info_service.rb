class IPInfoService < DataService
    base_uri 'ipinfo.io'

    def get_data(current_data)
        response = self.class.get("/#{current_data[:ip_address]}", {})
        translate(current_data, response, {
            host_name: "hostname",
            ip_coords: "loc",
            internet_provider: "org",
            ip_area_code: "phone"
        })
    end

end