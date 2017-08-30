class OnWaterService < DataService
    include HTTParty
    base_uri 'https://api.onwater.io/api/v1'

    def get_data(current_data)
        options = {access_token: ENV["ONWATER_KEY"]}
        lat = current_data[:latitude]
        long = current_data[:longitude]
        current_data[:on_water] = self.class.get("/results/#{lat},#{long}", options)["water"]
        current_data
    end
end