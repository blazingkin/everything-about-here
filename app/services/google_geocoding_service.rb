class GoogleGeocodingService < DataService
    base_uri 'https://maps.googleapis.com/maps/api/geocode'

    INCLUDE_IN_AREA_DATA = [:subarea_3, :subarea_2, :subarea_1, :locality, :country]

    def get_data(current_data)
        lat = current_data[:latitude]
        lng = current_data[:longitude]
        response = self.class.get("/json?latlng=#{lat},#{lng}&key=#{ENV['GOOGLE_SERVICE_KEY']}")
        p response
        first_result = response['results'].first
        first_result['address_components'].each do |component|
            map_component_to_code(current_data, component)
        end
        current_data[:area_data] = []
        INCLUDE_IN_AREA_DATA.each do |name|
            current_data[:area_data] << current_data[name] unless current_data[name].blank?
        end

        translate(current_data, first_result, {
            address_components: 'address_components',
            address: 'formatted_address',
            address_type: 'location_type',
        })
    end

    def map_component_to_code(current_data, component)
        types = component['types']
        long_name = component['long_name']
        if types.include? 'street_number'
            current_data[:street_number] = long_name
        elsif types.include? 'route'
            current_data[:street_name] = long_name
        elsif types.include? 'country'
            current_data[:country] = long_name
            current_data[:country_code] = component['short_name']
        elsif types.include? 'administrative_area_level_1'
            current_data[:subarea_1] = long_name
        elsif types.include? 'administrative_area_level_2'
            current_data[:subarea_2] = long_name
        elsif types.include? 'administrative_area_level_3'
            current_data[:subarea_3] = long_name
        elsif types.include? 'locality'
            current_data[:city] = long_name
        elsif types.include? 'neighborhood'
            current_data[:neighborhood] = long_name
        elsif types.include? 'postal_code'
            current_data[:postal_code] = long_name
        else
            current_data[:extra_geographical_info] ||= []
            current_data[:extra_geographical_info] << {types => long_name}
        end
    end

end