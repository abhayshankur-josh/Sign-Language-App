FactoryBot.define do
    factory :user do
        full_name { "John Doe" }
        sequence(:email) { |n| "user#{n}@example.com" }
        password { "password" }
        password_confirmation { "password" }
        active { true }
        # role_id { create(:role).id }

        trait :learner do
            role_id { create(:role, :learner).id }
        end

        trait :expert do
            role_id { create(:role, :expert).id }
        end

        trait :admin do
            role_id { create(:role, :admin).id }
        end
    end
end
