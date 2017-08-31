class GooglePlaceService < DataService
    base_uri 'https://maps.googleapis.com/maps/api/place/nearbysearch'

    def get_data(current_data)
        lat = current_data[:latitude]
        long = current_data[:longitude]
        response = self.class.get("/json?key=#{ENV['GOOGLE_SERVICE_KEY']}&location=#{lat},#{long}&rankby=distance")
        translate(current_data, response, {
            google_places: 'results'
        })
    end

end