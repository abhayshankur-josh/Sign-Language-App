require 'rails_helper'

RSpec.describe Experts::Create, type: :service do
  describe '#create' do
    let(:valid_attributes) do
      {
        email: 'test@example.com',
        username: 'testuser',
        password: 'password123',
        confirm_password: 'password123'
      }
    end

    let(:invalid_attributes) do
      {
        email: 'test@example.com',
        username: 'testuser',
        password: 'password123',
        confirm_password: 'password321' # Mismatched passwords
      }
    end

    subject { described_class.new(attributes) }

    context 'when attributes are valid' do
      let(:attributes) { valid_attributes }

      it 'creates an expert record successfully' do
        expect { subject.create }.to change(User, :count).by(1)
        result = subject.create
        expect(result[:success]).to be true
        expect(result[:message]).to be_a(User)
      end
    end

    context 'when passwords do not match' do
      let(:attributes) { invalid_attributes }

      it 'raises an ArgumentError' do
        expect { subject.create }.to raise_error(ArgumentError, 'Password Mismatch!')
      end

      it 'does not create an expert record' do
        expect { subject.create rescue nil }.not_to change(User, :count)
      end
    end

    context 'when an exception occurs during record creation' do
      let(:attributes) { valid_attributes }

      before do
        allow_any_instance_of(User).to receive(:save!).and_raise(StandardError, 'Something went wrong')
      end

      it 'logs the exception and returns an error message' do
        expect(Rails.logger).to receive(:error).with(/Exception: Something went wrong/)
        result = subject.create rescue nil
        expect(result[:success]).to be false
        expect(result[:message]).to eq('Exception!')
      end
    end
  end
end
