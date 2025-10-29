class Course < ApplicationRecord
  # Chaque cours peut avoir un document (PDF, PPT, etc.) attaché.
  has_one_attached :document, dependent: :purge
end
