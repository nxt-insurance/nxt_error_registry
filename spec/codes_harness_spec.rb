RSpec.describe NxtErrorRegistry::CodesHarness do
  subject { described_class.instance }

  def test_class
    Class.new do
      extend NxtErrorRegistry
    end
  end

  BadError = Class.new(StandardError)

  describe '#generate_code' do
    before do
      expect(SecureRandom).to receive(:hex).and_return('123456')
    end

    it 'generates the next code' do
      expect(subject.generate_code).to eq('123.456')
    end
  end
end
