class DigitalAddress
  RADIUS = 0.024384 / 2 # 80ft in killometres
  MIN_RADIUS = RADIUS / 2 # 80ft in killometres
  attr_accessor :geo_query, :query, :location, :address

  # Process geocode information
  # @return [Boolean]
  def processed?(query)
    @query = query
    @geo_query = GeoQuery.new(@query)
    if @geo_query.valid?
      point = @geo_query.result.coordinates
      box = Geocoder::Calculations.bounding_box(point, RADIUS,
                                                units: :km, min_radius: MIN_RADIUS)
      @location = Location.within_bounding_box(box)
      if @location.present?
        @address = @location.first.code
        return true
      else
        return generate_address
      end
    end
    false
  end

  private

  # Write to DB and generate a new address code
  def generate_address
    region = Region.find_or_create_by(name: @geo_query.region)
    city = region.cities.find_or_create_by(name: @geo_query.city)
    district = city.districts.find_or_create_by(name: @geo_query.district)
    @location = district.locations.find_or_create_by(latitude: @geo_query.latitude,
                                                     longitude: @geo_query.longitude)
    if @location.present?
      @address = location.code
      true
    else
      false
    end
  end
end