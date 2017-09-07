class WeatherService < DataService
    base_uri 'http://api.openweathermap.org/data/2.5'

    def get_data(current_data)
        lat = current_data[:latitude]
        lon = current_data[:longitude]
        short_lat = lat&.to_f&.round(3)
        short_lon = lon&.to_f&.round(3)
        appid = ENV['OPEN_WEATHER_MAP_KEY']
        response = Rails.cache.fetch("openweather/#{short_lat},#{short_lon}", :expires => 2.hours) do
            self.class.get("/weather?lat=#{lat}&lon=#{lon}&appid=#{appid}", {}).parsed_response
        end
        translate(current_data, response, {
            weather: "weather",
            weather_numeric: "main",
            wind: "wind",
            rain: "rain",
            cloud: "clouds",
            city: "name",
            visibility: 'visibility'
        })
    end

end