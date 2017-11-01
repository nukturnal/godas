class City < ApplicationRecord
  include CommonUtils
  belongs_to :region
  has_many :districts
  has_many :locations, through: :districts

  before_validation do
    self.code = city_code(name) if name.present?
  end

  validates :name, presence: true, uniqueness: true
  validates :code, presence: true, uniqueness: true
end
