class FccFipsService < DataService


    def get_data(current_data)
        lat = current_data[:latitude]&.to_f&.round(4)
        lon = current_data[:longitude]&.to_f&.round(4)
        response = Rails.cache.fetch("fips/#{lat},#{lon}", expires_in: 5.weeks) do
            HTTParty.get("https://geo.fcc.gov/api/census/block/find?latitude=#{lat}&longitude=#{lon}&format=json").parsed_response
        end
        p response
        current_data[:FIPS] = response.dig('Block', 'FIPS')
        current_data[:FIPS_state] = current_data[:FIPS].to_s[0..1]
        current_data[:FIPS_county] = current_data[:FIPS].to_s[2..4]
        current_data[:FIPS_tract] = current_data[:FIPS].to_s[5..11]
        current_data[:county] = response.dig('County', 'name')
        current_data[:state_abbreviation] = response.dig('State', 'code')
        current_data[:state] = response.dig('State', 'name')
        current_data
    end

end