require 'spec_helper'

RSpec.describe UsersController, type: :controller do
  let(:valid_interests) { [ 'Reading', 'Sports' ] }
  let(:valid_skills) { 'Ruby, Rails' }
  let(:invalid_attributes) { { email: nil } }
  let(:valid_attributes) do
    {
      surname: "Doe",
      name: "John",
      patronymic: "Michael",
      email: "user#{SecureRandom.uuid}@example.com",
      age: 30,
      nationality: "American",
      country: "USA",
      gender: "male",
      interests: valid_interests,
      skills: valid_skills
    }
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'returns the created user as JSON' do
        post :create, params: { user: valid_attributes }
        json_response = JSON.parse(response.body)

        expect(json_response['surname']).to eq(valid_attributes[:surname])
        expect(json_response['name']).to eq(valid_attributes[:name])
        expect(json_response['email']).to eq(valid_attributes[:email])
        expect(json_response['password']).to be_nil
      end
    end

    context 'with invalid attributes' do
      it 'returns error messages' do
        post :create, params: { user: invalid_attributes }
        json_response = JSON.parse(response.body)

        expect(json_response['errors']).to be_a(Hash)
        expect(json_response['errors']).to have_key('age')
        expect(json_response['errors']['age']).to include("is required")
        expect(json_response['errors']).to have_key('country')
        expect(json_response['errors']['country']).to include("is required")
        expect(json_response['errors']).to have_key('gender')
        expect(json_response['errors']['gender']).to include("is required")
        expect(json_response['errors']).to have_key('skills')
        expect(json_response['errors']['skills']).to include("is required")
        expect(json_response['errors']).to have_key('interests')
        expect(json_response['errors']['interests']).to include("is required")
      end
    end
  end
end
