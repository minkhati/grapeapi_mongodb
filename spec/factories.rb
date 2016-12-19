# spec/factories.rb
FactoryGirl.define do
  factory :timecard do
    username 'sample user'
    occurrence '2016-12-19'
    card_id '11'
  end

  factory :timeentry do
    time '2016-12-19T11-11-11-0001'
    timecard_id '11'
    association :timecard, factory: :timecard
  end

end