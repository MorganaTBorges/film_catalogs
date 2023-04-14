class FilmCatalogSerializer < ActiveModel::Serializer
  attributes :id, :title, :genre, :year, :country, :published_at, :description

  def genre
    object.type
  end

  def year
    object.release_year
  end

  def published_at
    object.date_added
  end
end