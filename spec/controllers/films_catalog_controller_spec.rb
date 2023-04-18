require "rails_helper"

RSpec.describe FilmCatalogsController, type: :controller do
  describe "POST #create" do
    context "with valid CSV file" do
      #let(:file) { File.read(Rails.root.join('spec', 'support', 'mocks', 'films.csv')) }
      let(:file) { fixture_file_upload(Rails.root.join('spec', 'support', 'mocks', 'films.csv')) }

      it "creates new film records" do
        expect {
          post :create, params: { file: file }
        }.to change(FilmCatalog, :count).by(3)

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["message"]).to eq("CSV importado com sucesso!")
      end
    end
  end

  describe "GET #index" do
    subject { get :index, format: :json }

    context "when there is no product_batch_submit" do
      it "should render not found status" do
        subject
        expect(response).to have_http_status(404)
      end
    end

    context "api" do
      let(:response_expected) do
        {
          "steps" => [
            {
              "title" => "solicitou o pro",
              "tracking_time" => product_batch_submit.created_at.strftime("%d/%m/%y - %Hh%M"),
              "description" => nil,
              "style" => {
                "enabled" => true,
                "dot_color" => "#5B5855"
              }
            }
          ],
          "tracking_code" => nil
        }
      end

      it "should render successful status" do
        subject


        expect(response).to have_http_status(200)
      end


      it "should match response body to expected response body" do
        subject
        expect(json_page).to  match(response_expected)
      end
    end
  end
end
