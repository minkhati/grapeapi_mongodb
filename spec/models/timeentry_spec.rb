# spec/models/timeentry_spec.rb
require 'spec_helper'

describe Timeentry do

  it 'has a valid factory' do
    expect(build(:timeentry)).to be_valid
  end

  describe 'validations' do

    it 'is invalid without a timecard_id' do
      expect(build(:timeentry, timecard_id: nil)).to_not be_valid
    end

    it 'is invalid without a time' do
      expect(build(:timeentry, time: nil)).to_not be_valid
    end

  end

end