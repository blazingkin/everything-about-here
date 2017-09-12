module HomeHelper

    RAD_PER_DEG = Math::PI / 180
    RM = 6371000 # Earth radius in meters
    
    def distance_between_in_m(lat1, lon1, lat2, lon2)
      lat1_rad, lat2_rad = lat1 * RAD_PER_DEG, lat2 * RAD_PER_DEG
      lon1_rad, lon2_rad = lon1 * RAD_PER_DEG, lon2 * RAD_PER_DEG
    
      a = Math.sin((lat2_rad - lat1_rad) / 2) ** 2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin((lon2_rad - lon1_rad) / 2) ** 2
      c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1 - a))
    
      RM * c # Delta in meters
    end

    def distance_to(current_data, lat, long)
        lat1 = current_data[:latitude].to_f
        lon1 = current_data[:longitude].to_f
        meter_to_km_mi(distance_between_in_m(lat1, lon1, lat, long))
    end

    def distance_to_place(current_data, place)
        lat = place.dig('geometry', 'location', 'lat')
        lng = place.dig('geometry', 'location', 'lng')
        return distance_to(current_data, lat, lng) unless lat.blank? || lng.blank?
        return "unknown"
    end

    def price_level_tag(place)
        price_level = place['price_level']
        '$' * price_level unless price_level.blank?
    end

    def rating_tag(place)
        rating = place['rating']&.to_i
        '★' * rating unless rating.blank?
    end

    def array_list_format(arr)
        arr.inject("") { |a, b| a + b.to_s + ", " }.chomp(', ')
    end

    def truncate(number, length)
        number.to_f.round(length)
    end

    def get_weather_icon(weather_icon)
        case weather_icon
            when '01d' # clear day
                wi_icon('wi-day-sunny')
            when '01n'
                wi_icon('wi-night-clear')
            when '02d'
                wi_icon('wi-day-cloudy')
            when '02n'
                wi_icon('wi-night-alt-cloudy')
            when '03d'
                wi_icon('wi-cloud')
            when '03n'
                wi_icon('wi-cloud')
            when '04d'
                wi_icon('wi-cloudy')
            when '04n'
                wi_icon('wi-cloudy')
            when '09d'
                wi_icon('wi-day-showers')
            when '09n'
                wi_icon('wi-night-alt-showers')
            when '10d'
                wi_icon('wi-rain')
            when '10n'
                wi_icon('wi-rain')
            when '11d'
                wi_icon('wi-thunderstorm')
            when '11n'
                wi_icon('wi-thunderstorm')
            when '13d'
                wi_icon('wi-snowflake-cold')
            when '13n'
                wi_icon('wi-snowflake-cold')
            when '50d'
                wi_icon('wi-day-fog')
            when '50n'
                wi_icon('wi-night-fog')
        end
    end

    def render_open_tag(place)
        if place.dig("opening_hours", "open_now")
            return "Open"
        else
            return ""
        end
    end

    def temperature_helper(temp)
        return "" if temp.blank?
        tempK = "#{temp} tempK".to_unit
        tempC = truncate(tempK.convert_to('tempC').scalar, 2)
        tempF = truncate(tempK.convert_to('tempF').scalar, 2)
        "#{tempC}° C / #{tempF}° F"
    end

    def meter_to_km_mi(met)
        return "" if met.blank?
        meter = "#{met} meter".to_unit
        ki = truncate(meter.convert_to('kilometer').scalar, 2)
        mi = truncate(meter.convert_to('mile').scalar, 2)
        "#{ki} km / #{mi} mi"
    end

    def ft_to_km_mi(ft)
        return "" if ft.blank?
        feet = "#{ft} feet".to_unit
        km = truncate(feet.convert_to('kilometer').scalar, 2)
        mi = truncate(feet.convert_to('mile').scalar, 2)
        "#{km} km / #{mi} mi"
    end

    def size_for_n_elements(n)
        return 0 if n == 0
        (12/n).floor
    end

    def precision_helper(type)
        case type
            when 'ROOFTOP'
                'Precise'
            when 'RANGE_INTERPOLATED'
                'Approximate'
            when 'GEOMETRIC_CENTER'
                'Approximate'
            when 'APPROXIMATE'
                'Approximate'
        end
    end

end
