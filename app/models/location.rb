class Location < ApplicationRecord
  include Locations::Geocoder
  include Locations::DigitalAddress

  attribute :coordinates, :string
  attribute :location_name, :string

  validates :latitude, presence: true, unless: Proc.new { |a| a.coordinates.blank? }
  validates :longitude, presence: true, unless: Proc.new { |a| a.coordinates.blank? }
end
