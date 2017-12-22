class LanguageService < DataService

    base_uri 'https://api.census.gov/data/2013/language'

    def extract_info(response, num)
        response.each do |point|
            return point[0].to_i if point[1] == num.to_s
        end
        0
    end

    def get_data(current_data)
        lat = current_data[:latitude]&.to_f&.round(4)
        lon = current_data[:longitude]&.to_f&.round(4)
        response = Rails.cache.fetch("FIPS/#{current_data[:FIPS_state]},#{current_data[:FIPS_county]}", expires_in: 5.weeks) do
            self.class.get("?get=EST&for=county:#{current_data[:FIPS_county]}&in=state:#{current_data[:FIPS_state]}&LAN7=1,2,3,4,5,6,7&key=#{ENV['CENSUS_DATA_KEY']}").parsed_response
        end
        current_data[:language_level] = :county
        if response.blank?
            response = Rails.cache.fetch("FIPS/#{current_data[:FIPS_state]}", expires_in: 5.weeks) do
                self.class.get("?get=EST&for=state:#{current_data[:FIPS_state]}&LAN7=1,2,3,4,5,6,7&key=#{ENV['CENSUS_DATA_KEY']}").parsed_response
            end
            current_data[:language_level] = :state
        end
        current_data[:demographic_languages] = {}
        current_data[:demographic_languages]['English Only'] = extract_info(response, 2)
        current_data[:demographic_languages]['Spanish'] = extract_info(response, 4) unless extract_info(response, 4) == 0
        current_data[:demographic_languages]['Indo-European'] = extract_info(response, 5)
        current_data[:demographic_languages]['Asian and Pacific Island'] = extract_info(response, 6)
        current_data[:demographic_languages]['Other'] = extract_info(response, 7)
        current_data
    end

end