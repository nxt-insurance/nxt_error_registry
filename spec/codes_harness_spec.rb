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
      expect(SecureRandom).to receive(:uuid).and_return('5c8152cd-b8b9-4fb0-a5fe-5c11d200affc')
    end

    it 'generates the next code' do
      expect(subject.generate_code).to eq('5c8152cd-b8b9-4fb0-a5fe-5c11d200affc')
    end
  end
end
