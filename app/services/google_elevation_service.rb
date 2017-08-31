class GoogleElevationService < DataService
    base_uri 'https://maps.googleapis.com/maps/api/elevation'

    def get_data(current_data)
        lat = current_data[:latitude]
        lon = current_data[:longitude]
        response = self.class.get("/json?key=#{ENV['GOOGLE_SERVICE_KEY']}&locations=#{lat},#{lon}")
        current_data[:elevation] = response['results'].first['elevation']
        current_data
    end

end