class WeatherService < DataService
    base_uri 'http://api.openweathermap.org/data/2.5'

    def get_data(current_data)
        lat = current_data[:latitude]
        lon = current_data[:longitude]
        appid = ENV['OPEN_WEATHER_MAP_KEY']
        response = self.class.get("/weather?lat=#{lat}&lon=#{lon}&appid=#{appid}", {})
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