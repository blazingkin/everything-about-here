class GoogleElevationService < DataService
    base_uri 'https://maps.googleapis.com/maps/api/elevation'

    def get_data(current_data)
        lat = current_data[:latitude]
        lon = current_data[:longitude]
        short_lat = lat&.to_f&.round(3)
        short_lon = lon&.to_f&.round(3)
        response = Rails.cache.fetch("elevation/#{short_lat},#{short_lon}", :expires => 5.days) do
            self.class.get("/json?key=#{ENV['GOOGLE_SERVICE_KEY']}&locations=#{lat},#{lon}").parsed_response
        end
        current_data[:elevation] = response['results'].first['elevation']
        current_data
    end

end