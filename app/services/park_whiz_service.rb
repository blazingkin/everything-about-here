class ParkWhizService < DataService
    base_uri 'https://api.parkwhiz.com'

    def get_data(current_data)
        lat = current_data[:latitude]
        lng = current_data[:longitude]
        short_lat = lat&.to_f&.round(3)
        short_lon = lng&.to_f&.round(3)
        venue_response = Rails.cache.fetch("parkwhiz_venue/#{short_lat},#{short_lon}", :expires => 1.day) do
            self.class.get("/venue/search/?lat=#{lat}&lng=#{lng}&key=#{ENV['PARK_WHIZ_KEY']}").parsed_response
        end
        current_data[:nearby_venues] = venue_response
        parking_response = Rails.cache.fetch("parkwhiz_parking/#{short_lat},#{short_lon}", :expires => 1.day) do
            self.class.get("/search/?lat=#{lat}&lng=#{lng}&key=#{ENV['PARK_WHIZ_KEY']}").parsed_response
        end
        current_data[:nearby_parking] = parking_response["parking_listings"]
        current_data
    end

end