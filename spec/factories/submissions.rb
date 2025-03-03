FactoryBot.define do
    factory :submission do
        sign_id { create(:sign).id }
        submitted_by_id { create(:user).id }
        approved_by_id { nil }

        trait :approved do
            approved_by_id { create(:user).id }
        end
      # association :sign, factory: :sign
      # association :submitted_by, factory: :user
      # association :approved_by, factory: :user, strategy: :build
    end
end
