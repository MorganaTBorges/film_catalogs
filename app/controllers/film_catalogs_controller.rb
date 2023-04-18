class FilmCatalogsController < ApplicationController
  require 'csv'

  def create
    csv_text = File.read(params[:file].path)
    csv = CSV.parse(csv_text, headers: true)

    films = csv.map do |row|
      FilmCatalog.find_or_create_by(film_params(row))
      #FilmCatalog.create!(film_params(row))
    end

    render json: { message: "CSV importado com sucesso!" }, status: :ok
  end

  def index
    films = FilmCatalog.where(filters)
    render json: films.order(release_year: :asc)
  end

  private

  def film_params(row)
    row.to_hash.slice('show_id', 'type', 'title', 'director', 'cast', 'country',
                      'date_added', 'release_year', 'duration', 'listed_in', 'description')
  end

  def filters
    params.permit(:show_id, :type, :title, :director, :cast, :country, :date_added, :release_year,
                  :duration, :listed_in, :description)
  end
end
