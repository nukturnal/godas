class Location < ApplicationRecord
  include Locations::Geocoder

  belongs_to :district

  attribute :coordinates, :string
  attribute :location_name, :string

  validates :latitude, presence: true, unless: Proc.new { |a| a.coordinates.blank? }
  validates :longitude, presence: true, unless: Proc.new { |a| a.coordinates.blank? }

  before_create :hierarchy_codes

  private

  def hierarchy_codes
    result = District.includes(city: :region).where('districts.id = ?', district_id).first
    if result.present?
      self.code = "#{result.city.region.code}.#{result.city.code}.#{result.code}"
    end
  end
end
