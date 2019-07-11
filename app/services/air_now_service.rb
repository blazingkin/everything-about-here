class AirNowService < DataService

    base_uri 'https://www.airnowapi.org/aq/forecast/latLong/'

    def get_data(current_data)
        lat = current_data[:latitude]&.to_f&.round(4)
        lon = current_data[:longitude]&.to_f&.round(4)
        response = Rails.cache.fetch("air-quality/#{lat},#{lon}", expires_in: 3.hours) do
            response = self.class.get("?format=application/json&date=2019-07-09&latitude=#{lat}&longitude=#{lon}&distance=25&API_KEY=#{ENV['AIRNOW_KEY']}").parsed_response
        end
        current_data[:air_quality] = {}
        response.each do |data|
            date = data["DateForecast"].strip
            # Create the map for the forecast if it doesn't yet exist
            if !current_data[:air_quality].has_key? date
              current_data[:air_quality][date] = {}
            end

            current_data[:air_quality][date][data["ParameterName"]] = {}
            current_data[:air_quality][date][data["ParameterName"]][:aqi] = data["AQI"]
            current_data[:air_quality][date][data["ParameterName"]][:human_readable_quality] = data["Category"]["Name"]
        end
        current_data
    end
end