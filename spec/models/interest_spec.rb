require 'spec_helper'

RSpec.describe Interest, type: :model do
  describe 'associations' do
    it { should have_and_belong_to_many(:users) }
  end
end
