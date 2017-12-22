class FccFipsService < DataService

    base_uri 'http://data.fcc.gov/api/block/find'

    def get_data(current_data)
        lat = current_data[:latitude]&.to_f&.round(4)
        lon = current_data[:longitude]&.to_f&.round(4)
        response = Rails.cache.fetch("language/#{lat},#{lon}", expires_in: 5.weeks) do
            self.class.get("?latitude=#{lat}&longitude=#{lon}").parsed_response
        end
        current_data[:FIPS] = response.dig('Response', 'Block', 'FIPS')
        current_data[:FIPS_state] = current_data[:FIPS].to_s[0..1].to_i
        current_data[:FIPS_county] = current_data[:FIPS].to_s[2..4].to_i
        current_data[:FIPS_tract] = current_data[:FIPS].to_s[5..11].to_i
        current_data[:county] = response.dig('Response', 'County', 'name')
        current_data[:state_abbreviation] = response.dig('Response', 'State', 'code')
        current_data[:state] = response.dig('Response', 'State', 'name')
        current_data
    end

end