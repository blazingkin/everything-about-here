class ParkWhizService < DataService
    base_uri 'https://api.parkwhiz.com'

    def get_data(current_data)
        lat = current_data[:latitude]
        lng = current_data[:longitude]
        venue_response = self.class.get("/venue/search/?lat=#{lat}&lng=#{lng}&key=#{ENV['PARK_WHIZ_KEY']}")
        p venue_response
        current_data[:nearby_venues] = venue_response
        parking_response = self.class.get("/search/?lat=#{lat}&lng=#{lng}&key=#{ENV['PARK_WHIZ_KEY']}")
        p parking_response
        current_data[:nearby_parking] = parking_response["parking_listings"]
        current_data
    end

end