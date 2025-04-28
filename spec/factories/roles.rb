FactoryBot.define do
  factory :role do
    sequence(:role_name) { |n| [ RoleQuery::ROLE_ADMIN, RoleQuery::ROLE_EXPERT, RoleQuery::ROLE_USER ][n % 3] }

    trait :admin do
      role_name { RoleQuery::ROLE_ADMIN }
    end

    trait :expert do
      role_name { RoleQuery::ROLE_EXPERT }
    end

    trait :learner do
      role_name { RoleQuery::ROLE_USER }
    end
  end
end
