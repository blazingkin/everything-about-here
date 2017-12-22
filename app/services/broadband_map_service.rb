class BroadbandMapService < DataService

    base_uri 'https://www.broadbandmap.gov/broadbandmap/'

    def get_data(current_data)
        lat = current_data[:latitude]&.to_f&.round(4)
        lon = current_data[:longitude]&.to_f&.round(4)
        response = Rails.cache.fetch("broadbandmap/#{lat},#{lon}", expires_in: 3.months) do
            self.class.get("/demographic/2014/coordinates?latitude=#{lat}&longitude=#{lon}&format=json", {}).parsed_response
        end
        translate(current_data, response["Results"], {
            income_poverty: "incomeBelowPoverty",
            income_median: "medianIncome",
            income_less_than_25k: "incomeLessThan25",
            income_less_than_50k: "incomeBetween25to50",
            income_less_than_100k: "incomeBetween50to100",
            income_less_than_200k: "incomeBetween100to200",
            income_greater_than_200k: "incomeGreater200",
            education_high_school_graduation: "educationHighSchoolGraduate",
            education_bachelors_or_better: "educationBachelorOrGreater"
        })
        p current_data
    end

end