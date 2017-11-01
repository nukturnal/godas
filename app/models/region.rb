class Region < ApplicationRecord
  include CommonUtils
  has_many :cities
  has_many :districts, through: :cities

  before_validation do
    self.code = region_code(name) if name.present?
  end

  validates :name, presence: true, uniqueness: true
  validates :code, presence: true, uniqueness: true
end
