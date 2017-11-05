module Locations
  module Geocoder
    extend ActiveSupport::Concern

    included do
      reverse_geocoded_by :latitude, :longitude do |obj, results|
        if geo = results.first
          obj.address = geo.address
        end
      end

      before_validation :check_coordinates
      after_validation :reverse_geocode, if: Proc.new { |a| coordinates_available? }
    end

    def coordinates_available?
      longitude.present? and latitude.present?
    end

    def check_coordinates
      return nil if coordinates.blank?
      carray = coordinates.split(',')

      if carray.size != 2
        return errors.add(:coordinates, "invalid values provided")
      end

      self.latitude = carray.first.squish
      self.longitude = carray.last.squish
    end
  end
end