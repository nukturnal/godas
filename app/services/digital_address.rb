class DigitalAddress
  RADIUS = 0.2 # lowest acceptable kilometer Geocoder Library limitation
  FEET_PER_KM = 3280.84
  ADDRESS_BLOCK = 80 # Square Feet
  attr_accessor :geo_query, :longitude, :latitude, :locations, :address, :distances, :query

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
          @address = location.digital_address
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
    region = Region.find_or_create_by(name: @geo_query.region)
    city = region.cities.find_or_create_by(name: @geo_query.city)
    district = city.districts.find_or_create_by(name: @geo_query.district)
    location = district.locations.find_or_create_by(latitude: @latitude,
                                                     longitude: @longitude)
    if location.present?
      @address = location.digital_address
      true
    else
      false
    end
  end
end