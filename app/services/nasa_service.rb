class NASAService < DataService
    base_uri 'https://api.nasa.gov/planetary/earth'

    def get_data(current_data)
        lat = current_data[:latitude]&.to_f&.round(2)
        lon = current_data[:longitude]&.to_f&.round(2)
        images = self.class.get("/assets?lat=#{lat}&lon=#{lon}&api_key=#{ENV['NASA_KEY']}")
        date = ''
        begin
            date = images['results'].last['date'].split('T')[0]
            current_data[:nasa_img_date] = date
        rescue Exception => e
        end
        response = self.class.get("/imagery?lat=#{lat}&lon=#{lon}&api_key=#{ENV['NASA_KEY']}&cloud_score=True&date=#{date}")
        translate(current_data, response, {
           nasa_img: 'url',
           nasa_cloud_cover: 'cloud_score' 
        })
    end

end