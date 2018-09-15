class DemographicsService < DataService
    base_uri 'https://api.census.gov/data/2010/dec/sf1'

    def get_data(current_data)
        lat = current_data[:latitude]&.to_f&.round(4)
        lon = current_data[:longitude]&.to_f&.round(4)
        variables = "P003002,P003003,P003004,P003005,P003006,P003007,P003008,P012001,P012002,P013001,P037001"
        response = Rails.cache.fetch("demographics/#{current_data[:FIPS_state]},#{current_data[:FIPS_county]}", expires_in: 5.weeks) do
            self.class.get("?get=#{variables}&for=county:#{current_data[:FIPS_county]}&in=state:#{current_data[:FIPS_state]}&key=#{ENV['CENSUS_DATA_KEY']}").parsed_response
        end
        current_data[:demographic_races] = {}
        current_data[:demographic_races]['White'] = response[1][0].to_i
        current_data[:demographic_races]['African'] = response[1][1].to_i
        current_data[:demographic_races]['Native American'] = response[1][2].to_i
        current_data[:demographic_races]['Asian'] = response[1][3].to_i
        current_data[:demographic_races]['Pacific Islander'] = response[1][4].to_i
        current_data[:demographic_races]['Two Or More'] = response[1][6].to_i
        current_data[:demographic_races]['Other'] = response[1][5].to_i

        current_data[:demographic_sex] = {}
        current_data[:demographic_sex]['Male'] = response[1][8].to_i
        current_data[:demographic_sex]['Female'] = response[1][7].to_i - response[1][8].to_i

        current_data[:demographic_median_age] = response[1][9].to_f
        current_data[:demographic_family_size] = response[1][10].to_f
        current_data
    end

end

=begin
https://www.census.gov/data/developers/data-sets/decennial-census.html

P0030001 - Total population
P0030002 - White population
P0030003 - African American population
P0030004 - Indian / Alaskan Native population
P0030005 - Asian population
P0030006 - Hawaiian / Pacific Islander
P0030007 - Other
P0030008 - Two or more races

P0120001 - Total Population
P0120002 - Male
(Female is calculated)

P0130001 - Median Age

P0370001 - Average family size
=end