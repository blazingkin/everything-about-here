class GooglePlaceService < DataService
    base_uri 'https://maps.googleapis.com/maps/api/place/nearbysearch'

    def get_data(current_data)
        lat = current_data[:latitude]
        long = current_data[:longitude]
        short_lat = lat&.to_f&.round(3)
        short_lon = long&.to_f&.round(3)
        response = Rails.cache.fetch("place/#{short_lat},#{short_lon}", :expires => 1.day) do
            self.class.get("/json?key=#{ENV['GOOGLE_SERVICE_KEY']}&location=#{lat},#{long}&rankby=distance").parsed_response
        end
        translate(current_data, response, {
            google_places: 'results'
        })
    end

end