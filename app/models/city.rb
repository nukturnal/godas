class City < ApplicationRecord
  include CommonUtils
  belongs_to :region
  has_many :districts
  has_many :locations, through: :districts

  before_validation do
    self.code = city_code(name) if name.present?
  end

  validates :name, presence: true, uniqueness: { scope: :region_id }
  validates :code, presence: true, uniqueness: { scope: [:name, :region_id] }
end
