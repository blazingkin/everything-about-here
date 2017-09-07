class CountryService < DataService
    base_uri 'https://restcountries.eu/rest/v2'

    def get_data(current_data)
        response = Rails.cache.fetch("restcountries/#{current_data[:country_code]}", :expires => 3.days) do
            self.class.get("/alpha/#{current_data[:country_code]}", {}).parsed_response
        end
        translate(current_data, response, {
            flag_image: "flag",
            borders: "borders",
            country_population: "population",
            country_land_area: "area",
            country_borders: "borders",
            country_extension: "callingCodes"
        })
    end

end