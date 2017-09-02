module HomeHelper

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
