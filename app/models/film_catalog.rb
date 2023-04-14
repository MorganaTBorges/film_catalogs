class FilmCatalog < ApplicationRecord
  validates :title, uniqueness: { scope: [:release_year, :country, :director] }

  self.inheritance_column = :inheritance_type

  def self.inheritance_column
    :inheritance_type
  end
end
