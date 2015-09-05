FactoryGirl.define do
  factory :ticket do
    sb_bet_id 456
    wager_date "2015-09-03 17:06:00"
    wager_type "Straight Wager"
    amount_wagered 10.0
    amount_to_win 9.09

    trait :pending do
      outcome "Pending"
    end

    trait :won do
      outcome "Won"
    end

    trait :lost do
      outcome "Lost"
    end
  end
end
