class Avion < ApplicationRecord
  has_many :reservations, dependent: :destroy
  has_many :vols, dependent: :destroy
end
