class District < ApplicationRecord
  include CommonUtils

  belongs_to :city
  has_many :locations

  before_validation do
    self.code = region_code(name) if name.present?
  end

  validates :name, presence: true, uniqueness:  { scope: :city_id }
  validates :code, presence: true, uniqueness:  { scope: :city_id }
end
