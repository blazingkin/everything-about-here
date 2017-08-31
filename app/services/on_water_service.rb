class OnWaterService < DataService
    base_uri 'https://api.onwater.io/api/v1'

    def get_data(current_data)
        options = {access_token: ENV["ONWATER_KEY"]}
        response = self.class.get("/results/#{current_data[:latitude]},#{current_data[:longitutde]}", options)
        translate(current_data, response, {
            on_water: "water"
        })
    end
end