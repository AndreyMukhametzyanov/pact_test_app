require 'spec_helper'

RSpec.describe Users::Create, type: :interaction do
  let(:valid_interests) { [ 'Reading', 'Sports' ] }
  let(:valid_skills) { 'Ruby, Rails' }

  def unique_email
    "user#{SecureRandom.uuid}@example.com"
  end

  let(:valid_params) do
    {
      surname: "Doe",
      name: "John",
      patronymic: "Michael",
      email: unique_email,
      age: 30,
      nationality: "American",
      country: "USA",
      gender: "male",
      interests: valid_interests,
      skills: valid_skills
    }
  end

  before(:each) { User.delete_all }

  describe 'creating a user' do
    context 'when valid params are provided' do
      it 'creates a user successfully' do
        result = Users::Create.run(valid_params)
        expect(result).to be_valid
        expect(User.exists?(email: valid_params[:email])).to be_truthy
      end

      it 'correctly sets full_name from surname, name and patronymic' do
        result = "#{valid_params[:surname]} #{valid_params[:name]} #{valid_params[:patronymic]}"
        user = Users::Create.run!(valid_params)
        expect(user.full_name).to eq(result)
      end
    end

    context 'when required attributes are missing' do
      [ :name, :email, :age, :nationality, :country, :gender ].each do |attr|
        it "fails when #{attr} is missing" do
          invalid_params = valid_params.except(attr)
          result = Users::Create.run(invalid_params)
          expect(result).not_to be_valid
          expect(result.errors[attr]).to include("is required")
        end
      end
    end

    context 'when email format is invalid' do
      it 'fails with an incorrect email format' do
        invalid_email_params = valid_params.merge(email: 'invalid_email')
        result = Users::Create.run(invalid_email_params)
        expect(result).not_to be_valid
        expect(result.errors[:email]).to include('is invalid')
      end
    end

    context 'when email is already taken' do
      before { create(:user, email: valid_params[:email]) }

      it 'fails with base error' do
        result = Users::Create.run(valid_params)
        expect(result).not_to be_valid
        expect(result.errors[:base]).to include(/User creation failed/)
      end
    end

    context 'when interests is not an array' do
      it 'fails with a validation error' do
        invalid_interests_params = valid_params.merge(interests: 'Not an array')
        result = Users::Create.run(invalid_interests_params)

        expect(result).not_to be_valid
        expect(result.errors.messages).to include(interests: [ 'is not a valid array' ])
      end
    end

    context 'when age is out of range' do
      it 'fails when age is too low' do
        result = Users::Create.run(valid_params.merge(age: 0))
        expect(result).not_to be_valid
        expect(result.errors[:age]).to include('must be greater than 0')
      end

      it 'fails when age is too high' do
        result = Users::Create.run(valid_params.merge(age: 91))
        expect(result).not_to be_valid
        expect(result.errors[:age]).to include('must be less than or equal to 90')
      end
    end

    context 'when gender is invalid' do
      it 'fails validation' do
        result = Users::Create.run(valid_params.merge(gender: 'other'))
        expect(result).not_to be_valid
        expect(result.errors[:gender]).to include('is not included in the list')
      end
    end

    context 'when interests and skills are empty' do
      it 'creates a user without errors' do
        empty_interests_params = valid_params.merge(interests: [], skills: '')
        result = Users::Create.run(empty_interests_params)
        expect(result).to be_valid
      end
    end

    context 'when user creation fails' do
      before do
        allow(User).to receive(:create!).and_raise(ActiveRecord::RecordInvalid.new(User.new))
        allow_any_instance_of(ActiveRecord::Base).to receive_message_chain(:errors, :full_messages)
                                                 .and_return([ "User creation failed: Validation failed: " ])
      end

      it 'does not create a user and shows the appropriate error message' do
        result = Users::Create.run(valid_params)
        expect(result).not_to be_valid
        expect(result.errors.full_messages.first).to include("User creation failed")
        expect(User.count).to eq(0)
      end
    end

    context 'when adding interests fails' do
      before do
        allow(Interest).to receive(:find_or_create_by!).and_raise(ActiveRecord::RecordInvalid)
      end

      it 'fails with an error' do
        result = Users::Create.run(valid_params)
        expect(result).not_to be_valid
        expect(result.errors[:base]).not_to be_empty
      end
    end

    context 'when adding skills fails' do
      before do
        allow(Skill).to receive(:find_or_create_by!).and_raise(ActiveRecord::RecordInvalid)
      end

      it 'fails with an error' do
        result = Users::Create.run(valid_params)
        expect(result).not_to be_valid
        expect(result.errors[:base]).not_to be_empty
      end
    end

    context 'when adding duplicate associations' do
      before do
        @user = Users::Create.run!(valid_params)
        @interest = Interest.first
        @skill = Skill.first
      end

      it 'prevents duplicate interests through association' do
        expect {
          @user.interests << @interest
        }.to raise_error(ActiveRecord::RecordNotUnique)
      end

      it 'prevents duplicate skills through association' do
        expect {
          @user.skills << @skill
        }.to raise_error(ActiveRecord::RecordNotUnique)
      end
    end
  end
end
