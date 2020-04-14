require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) do
    { "CONTENT_TYPE" => "application/json",
      "ACCEPT" => 'application/json' }
  end

  describe 'GET /api/v1/profiles/me' do
    let(:api_path) { '/api/v1/profiles/me' }

    it_behaves_like 'API autorizable' do
      let(:method) { :get }
    end

    context 'autorize' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'return 200 if token valid' do
        expect(response).to be_successful
      end

      it 'return all public fields' do
        %w[id email created_at updated_at].each do |attr|
          expect(json['user'][attr]).to eq me.send(attr).as_json
        end
      end

      it 'do not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(json).to_not have_key(attr)
        end
      end
    end
  end

  describe 'GET /api/v1/profiles' do
    let(:api_path) { '/api/v1/profiles' }

    it_behaves_like 'API autorizable' do
      let(:method) { :get }
    end

    context 'autorize' do
      let(:access_token) { create(:access_token) }
      let!(:users) { create_list(:user, 3) }
      let(:user) { users.first }
      let(:user_response) { json['users'].first }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'return 200 if token valid' do
        expect(response).to be_successful
      end

      it 'returns list of users' do
        expect(json['users'].size).to eq 3
      end

      it 'return all public fields' do
        %w[id email created_at updated_at].each do |attr|
          expect(user_response[attr]).to eq user.send(attr).as_json
        end
      end

      it 'do not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(user_response).to_not have_key(attr)
        end
      end
    end
  end
end
