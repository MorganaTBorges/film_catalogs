class FilmCatalogsController < ApplicationController
  require 'csv'

  def create
    csv_text = File.read(params[:file].path)
    csv = CSV.parse(csv_text, headers: true)

    csv.each do |row|
      FilmCatalog.create!(film_catalog_params(row.to_h))
    end

    render json: { message: "CSV importado com sucesso!" }, status: :ok
  end

  def index
    films = FilmCatalog.where(filters)
    render json: films.order(release_year: :asc)
  end

  private

  def filters
    params.permit(:show_id, :type, :title, :director, :cast, :country, :date_added, :release_year, :rating, :duration, :listed_in, :description)
  end

  def film_catalog_params(row_params)
    row_params.slice(:show_id, :type, :title, :director, :cast, :country,
                      :date_added, :release_year, :rating, :duration, :listed_in,
                      :description)
              .transform_keys { |key| key.to_s.underscore.to_sym }
  end
end