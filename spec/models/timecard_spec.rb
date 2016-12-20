# spec/models/timecard_spec.rb
require 'spec_helper'

describe Timecard do

  it 'has a valid factory' do
    expect(build(:timecard)).to be_valid
  end

  describe 'validations' do

    # it 'is invalid without a card_id' do
    #   expect(build(:timecard, card_id: nil)).to_not be_valid
    # end

    it 'is invalid without a username' do
      expect(build(:timecard, username: nil)).to_not be_valid
    end

    it 'is invalid without a occurrence' do
      expect(build(:timecard, occurrence: nil)).to_not be_valid
    end

    # it 'is invalid with a duplicated card_id' do
    #   create(:timecard)
    #   expect(build(:timecard)).to_not be_valid
    # end

  end

end