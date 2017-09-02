class GoogleMapEmbedService < DataService

    def get_data(current_data)
        embed_key = ENV['GOOGLE_MAP_EMBED_KEY']
        lat = current_data[:latitude]
        lon = current_data[:longitude]
        current_data[:google_map_embed] = "https://www.google.com/maps/embed/v1/view?key=#{embed_key}&center=#{lat},#{lon}&zoom=16&maptype=satellite"
        current_data
    end

end