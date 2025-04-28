require 'rails_helper'

RSpec.describe SignQuery, type: :model do
  before do
    @video_record = create(:video)
  end

  subject { SignQuery.instance }

  context "#attr_reader : signs" do
    it "fetch all available records from Sign." do
      expect(subject.signs).to match_array(Sign.all)
    end
  end

  context "when using #add_sign" do
    let(:title) { "Sample Title" }
    let(:description) { "Sample Description" }

    it "adds a valid sign record." do
      result = subject.add_sign(title, description, @video_record.id)
      expect {
        subject.add_sign(title, description, @video_record.id)
      }.to change(Sign, :count).by(1)
    end

    it "raises a exception when fails to add Sign." do
      expect {
        subject.add_sign(title, description, nil)
    }.to raise_error(Exception, "Exception in add_sign!")
    end
  end

  context "when using #update_status?" do
    let(:valid_sign) { create(:sign) }

    it "updates the status for a valid Sign." do
      result = subject.update_status?(valid_sign.id, :approved)
      expect(result).to be true
    end

    it "updates the status for a invalid Sign." do
      result = subject.update_status?(nil, :approved)
      expect(result).to be false
    end

    it "updates the status for a valid sign with invalid status." do
      result = subject.update_status?(valid_sign.id, :in_progress)
      expect(result).to be false
    end
  end
end
