class Location < ApplicationRecord
  include Locations::Geocoder

  belongs_to :district

  attribute :coordinates, :string

  validates :latitude, presence: true, unless: Proc.new { |a| a.coordinates.blank? }
  validates :longitude, presence: true, unless: Proc.new { |a| a.coordinates.blank? }

  before_create :hierarchy_codes

  def digital_address
    "#{region_code}/#{city_code}/#{code}"
  end

  private

  def generate_code
    total_address = Location.where(district_id: district_id).count
    new_address = "#{district_code}%04d" % (total_address + 1)
    if Location.exists?(district_id: district_id, code: new_address)
      generate_code
    else
      self.code = new_address
    end
  end

  def hierarchy_codes
    result = District.includes(city: :region).find(district_id)
    if result.present?
      self.city_code = result.city.code
      self.region_code = result.city.region.code
      self.district_code = result.code
      generate_code
    end
  end
end
