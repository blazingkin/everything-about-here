class OnWaterService < DataService
    base_uri 'https://api.onwater.io/api/v1'

    def get_data(current_data)
        response = Rails.cache.fetch("onwater/#{current_data[:short_lat]},#{current_data[:short_lon]}", expires_in: 1.week) do
            self.class.get("/results/#{current_data[:latitude]},#{current_data[:longitude]}").parsed_response
        end
        translate(current_data, response, {
            on_water: "water"
        })
    end
end