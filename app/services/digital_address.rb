class DigitalAddress
  RADIUS = 0.2 # lowest acceptable kilometer Geocoder Library limitation
  FEET_PER_KM = 3280.84
  ADDRESS_BLOCK = 60 # Square Feet
  NOT_LISTED = 'Not Listed'
  attr_accessor :geo_query, :longitude, :latitude, :locations, :formatted_address,
                :address, :distances, :query, :district, :region, :city

  # Process geocode information
  # @param latitude [Float]
  # @param longitude [Float]
  # @return [Boolean]
  def processed?(latitude, longitude)
    @latitude = latitude
    @longitude = longitude
    @query = [latitude, longitude]
    @geo_query = GeoQuery.new(*@query)
    if @geo_query.valid?
      @distances = []
      @locations = Location.near(@query, RADIUS, units: :km)
      return generate_address if @locations.blank?
      @locations.each do |location|
        @distances << location.distance * FEET_PER_KM
        if @distances.last <= ADDRESS_BLOCK
          set_address location
          break true
        else
          break generate_address
        end
      end
    else
      false
    end
  end

  private

  # Write to DB and generate a new address code
  def generate_address
    city_name = @geo_query.city.present? ? @geo_query.city : NOT_LISTED
    district_name = @geo_query.district.present? ? @geo_query.district : NOT_LISTED
    region = Region.find_or_create_by(name: @geo_query.region)
    city = region.cities.find_or_create_by(name: city_name)
    district = city.districts.find_or_create_by(name: district_name)
    location = district.locations.find_or_create_by(latitude: @latitude,
                                                     longitude: @longitude)
    if location.present?
      set_address location
      true
    else
      false
    end
  end

  # I know this suffers from N1 Issues
  # Will fix in performance updates
  def set_address(location = Location.new)
    @address = location.digital_address
    @formatted_address = location.address
    @city = @geo_query.city.present? ? @geo_query.city : NOT_LISTED
    @region = @geo_query.region
    @district = @geo_query.district
  end
end