require 'rspec'
require_relative '../mastermind/computer_secret_colors'

describe ComputerSecretColors do
  describe '#secret_numbers' do
    it 'returns secret numbers' do
      color = ComputerSecretColors.new
      expect(color.secret_numbers).to eql(color.secret_numbers)
    end
  end

  describe '#guesses' do
    it 'returns secret numbers' do
      color = ComputerSecretColors.new
      expect(color.secret_numbers).to eql(color.secret_numbers)
    end
  end
end
