require 'rails_helper'

RSpec.describe FilmCatalogsController, type: :controller do
  describe 'POST #create' do
    context 'quando um arquivo CSV válido é fornecido' do
      let(:csv_file) { fixture_file_upload('films.csv', 'text/csv') }
      before { post :create, params: { file: csv_file } }

      it 'retorna o status de sucesso' do
        expect(response).to have_http_status(:ok)
      end

      it 'retorna uma mensagem de sucesso' do
        expect(response.body).to include('CSV importado com sucesso!')
      end

      it 'cria os registros de filme corretamente' do
        expect(FilmCatalog.count).to eq(9)
      end
    end

    context 'quando nenhum arquivo CSV é fornecido' do
      before { post :create }

      it 'retorna um status não processável' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'retorna uma mensagem de erro' do
        expect(response.body).to include('Arquivo CSV não fornecido')
      end
    end
  end

  describe 'GET #index' do
    let!(:film1) { create(:film_catalog, title: 'Filme 1') }
    let!(:film2) { create(:film_catalog, title: 'Filme 2') }
    let!(:film3) { create(:film_catalog, title: 'Filme 3') }

    context 'quando nenhum filtro é fornecido' do
      before { get :index }

      it 'retorna o status de sucesso' do
        expect(response).to have_http_status(:ok)
      end

      it 'retorna todos os filmes em ordem ascendente de ano de lançamento' do
        expected_response = [film1, film2, film3].map { |f| f.attributes.stringify_keys }
        expect(JSON.parse(response.body)).to eq(expected_response)
      end
    end

    context 'quando filtros são fornecidos' do
      let!(:film4) { create(:film_catalog, title: 'Filme 4', release_year: 2020) }
      let!(:film5) { create(:film_catalog, title: 'Filme 5', release_year: 2022) }

      before { get :index, params: { release_year: 2022 } }

      it 'retorna o status de sucesso' do
        expect(response).to have_http_status(:ok)
      end

      it 'retorna apenas os filmes que correspondem aos filtros' do
        expected_response = [film5.attributes.stringify_keys]
        expect(JSON.parse(response.body)).to eq(expected_response)
      end
    end
  end
end
