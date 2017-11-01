module Locations
  module DigitalAddress
    extend ActiveSupport::Concern
    include CommonUtils

    included do
      after_validation :generate_digital_address
    end

    # Generate some labels, for now lets call them digital addresses
    # We can definitely improve on this part going forward.
    def generate_digital_address
      self.level_1_code = region_code(region)
      self.level_2_code = city_code(city)
      self.level_3_code = locality_name
      self.digital_address = [level_1_code, level_2_code, level_3_code].reject(&:blank?).join('-')
    end

    # Lets find something to replace blank localities
    # A22 came to mind, don't know why, but hey its a hobby project
    # I'm positive we can find something a more elegant approach later
    def locality_name
      name = region_code(locality)
      name.blank? ? 'A22' : name
    end
  end
end
