require 'rails_helper'

RSpec.describe FilmCatalogsController, type: :controller do
  describe 'POST #create' do
    context 'when a valid CSV file is provided' do
      let(:csv_file) { fixture_file_upload('films.csv', 'text/csv') }
      before { post :create, params: { file: csv_file } }

      it 'returns a success status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns a success message' do
        expect(response.body).to include('CSV imported successfully!')
      end

      it 'creates film records correctly' do
        expect(FilmCatalog.count).to eq(9)
      end
    end

    context 'when no CSV file is provided' do
      before { post :create }

      it 'returns an unprocessable entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns an error message' do
        expect(response.body).to include('CSV file not provided')
      end
    end
  end

  describe 'GET #index' do
    context 'when no filters are provided' do
      before { get :index }

      it 'returns a success status' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when filters are provided' do
      let(:csv_file) { fixture_file_upload('films.csv', 'text/csv') }

      before do
        post :create, params: { file: csv_file }
      end

      it 'returns a success status' do
        get :index, params: { release_year: 2022 }
        expect(response).to have_http_status(:ok)
      end

      it 'returns only films that match the filters' do
        expected_response = FilmCatalog.where(release_year: 2022).as_json
        get :index, params: { release_year: 2022 }
        expect(JSON.parse(response.body)).to eq(expected_response)
      end
    end
  end
end
