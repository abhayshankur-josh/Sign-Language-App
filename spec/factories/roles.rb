FactoryBot.define do
  factory :role do
    sequence(:role_name) { |n| [ "admin", "expert", "learner" ][n % 3] }

    trait :admin do
      role_name { "admin" }
    end

    trait :expert do
      role_name { "expert" }
    end

    trait :learner do
      role_name { "learner" }
    end
  end
end
