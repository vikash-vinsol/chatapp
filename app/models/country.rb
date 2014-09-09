class Country < ActiveRecord::Base
  validates :name, :iso, presence: true
  validates :name, :iso, uniqueness: true
end