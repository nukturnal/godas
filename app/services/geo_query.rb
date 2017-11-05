class GeoQuery
  attr_accessor :query, :result
  attr_accessor :region, :city, :district, :locality,
                :longitude, :latitude, :formatted_address, :locality

  def initialize(latitude, longitude)
    @query = [latitude, longitude]
  end

  def valid?
    return false if @query.blank?
    results = Geocoder.search(@query)
    if results.present?
      @result = results.first
      process_results
      true
    else
      false
    end
  end

  private

  def process_results
    return false if @result.blank?
    @region = @result.state
    @city = @result.city
    @district = @result.sub_state
    @longitude = @result.longitude
    @latitude = @result.latitude
    @locality = result_component(:sublocality)
    @formatted_address = @result.formatted_address
  end

  # pull other needed data attributes from results
  def result_component(component)
    rc = @result.address_components_of_type(component)
    return nil if rc.blank?
    rc.try(:first)['long_name']
  end
end