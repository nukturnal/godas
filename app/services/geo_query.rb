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

  # Currently supports Google & LocationIQ Results
  def process_results
    return false if @result.blank?
    @region = @result.state
    @city = @result.city
    @longitude = @result.longitude
    @latitude = @result.latitude

    case Geocoder.config.lookup
      when :location_iq
        @city = location_iq_city if @city.blank?
        @locality = @result.village
        @formatted_address = @result.address
        @district = @result.county
      when :google, :google_premier, :google_places_details, :google_places_search
        @locality = result_component(:sublocality)
        @formatted_address = @result.formatted_address
        @district = @result.sub_state
      else
        @district = nil
        @locality = nil
        @formatted_address = nil
    end
  end

  # pull other needed data attributes from results
  def result_component(component)
    rc = @result.address_components_of_type(component)
    return nil if rc.blank?
    rc.try(:first)['long_name']
  end

  # Copied from Geocoder Source
  # Added extra keys
  def location_iq_city
    %w(city town village hamlet suburb city_district neighbourhood).each do |key|
      return @result.data['address'][key] if @result.data['address'].key?(key)
    end
    return nil
  end
end