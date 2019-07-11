class NASAService < DataService


    def fetch_available_images(lat, lon)
        HTTParty.get("https://api.nasa.gov/planetary/earth/assets?lat=#{lat}&lon=#{lon}&api_key=#{ENV['NASA_KEY']}").parsed_response
    end

    def fetch_image_url(lat, lon, date)
        HTTParty.get("https://earth-imagery-api.herokuapp.com/earth/imagery/?lat=#{lat}&lon=#{lon}&cloud_score=True&date=#{date}")
    end

    def get_data(current_data)
        lat = current_data[:latitude]&.to_f&.round(4)
        lon = current_data[:longitude]&.to_f&.round(4)
        images = Rails.cache.fetch("nasa_planetary/#{lat},#{lon}", expires_in: 5.days) do
            fetch_available_images lat, lon
        end

        date = ''
        begin
            date = images['results'].last['date'].split('T')[0]
            current_data[:nasa_img_date] = date
        rescue Exception => e
        p e
        end
        response = fetch_image_url lat, lon, date
	translate(current_data, response, {
           nasa_img: 'url',
           nasa_cloud_cover: 'cloud_score' 
        })
    end

end
