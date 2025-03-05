FactoryBot.define do
    factory :submission do
        sign_id { create(:sign).id }
        submitted_by_id { create(:user, :expert).id }
        approved_by_id { nil }

        trait :approved do
            approved_by_id { build(:user, :expert).id }
        end
      # association :sign, factory: :sign
      # association :submitted_by, factory: :user
      # association :approved_by, factory: :user, strategy: :build
    end
end
