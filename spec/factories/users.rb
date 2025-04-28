FactoryBot.define do
    factory :user do
        full_name { "John Doe" }
        sequence(:email) { |n| "user#{n}@example.com" }
        password { "password" }
        password_confirmation { "password" }
        active { true }
        # role_id { create(:role).id }

        # trait :learner do
        #     role_id { create(:role, :learner).id }
        # end

        # trait :expert do
        #     role_id { create(:role, :expert).id }
        # end

        # trait :admin do
        #     role_id { create(:role, :admin).id }
        # end

        trait :learner do
            role_id { Role.find_or_create_by(role_name: RoleQuery::ROLE_USER).id }
        end

        trait :expert do
            role_id { Role.find_or_create_by(role_name: RoleQuery::ROLE_EXPERT).id }
        end

        trait :admin do
            role_id { Role.find_or_create_by(role_name: RoleQuery::ROLE_ADMIN).id }
        end
    end
end
