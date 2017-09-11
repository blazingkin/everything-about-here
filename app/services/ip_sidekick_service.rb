class IPSidekickService < DataService
    base_uri 'https://ipsidekick.com'

    def get_data(current_data)
        response = Rails.cache.fetch("ipsidekick/#{current_data[:ip_address]}", :expires => 2.hours) do
            self.class.get("/#{current_data[:ip_address]}", {}).parsed_response
        end
        translate(current_data, response, {
            country_code: "countryCode",
            country: "country",
            time_zone: "timeZoneName",
            time_zone_offset: "gmtOffset",
            holiday: "holiday"
        })
    end

end