RSpec.describe NxtErrorRegistry::CodesHarness do
  subject { described_class.new }

  def test_class
    Class.new do
      include NxtErrorRegistry
    end
  end

  BadError = Class.new(StandardError)

  describe '#codes_not_in_sequence' do
    let(:registry) { NxtErrorRegistry::Registry.send(:new) }

    context 'when the codes are in sequence' do
      before do
        allow(NxtErrorRegistry::Registry).to receive(:instance).and_return(registry)

        test_class.register_error :LevelOneError, type: BadError, code: '100.000'
        test_class.register_error :LevelOneError, type: BadError, code: '100.003'
        test_class.register_error :LevelOneError, type: BadError, code: '100.001'
        test_class.register_error :LevelOneError, type: BadError, code: '100.002'
      end

      it 'returns an empty array' do
        expect(subject.codes_not_in_sequence).to be_empty
      end
    end

    context 'when codes are not in sequence' do
      before do
        allow(NxtErrorRegistry::Registry).to receive(:instance).and_return(registry)

        test_class.register_error :LevelOneError, type: BadError, code: '100.000'
        test_class.register_error :LevelOneError, type: BadError, code: '100.003'
        test_class.register_error :LevelOneError, type: BadError, code: '100.007'
        test_class.register_error :LevelOneError, type: BadError, code: '100.009'
        test_class.register_error :LevelOneError, type: BadError, code: '200.009'
        test_class.register_error :LevelOneError, type: BadError, code: '100.002'
        test_class.register_error :LevelOneError, type: BadError, code: '100.005'
      end

      it 'returns the tuples with a distance greater one' do
        expect(
          subject.codes_not_in_sequence
        ).to eq([[100000, 100002], [100003, 100005], [100005, 100007], [100007, 100009], [100009, 200009]])
      end
    end
  end

  describe '#generate_code' do
    it 'generates the next code' do
      expect(subject.generate_code).to eq('100.00')
      test_class.register_error :LevelOneError, type: BadError, code: '100.001'
      test_class.register_error :LevelOneError, type: BadError, code: '100.002'
      expect(subject.generate_code).to eq('100.003')
      expect(subject.generate_code).to eq('100.003')
      test_class.register_error :LevelOneError, type: BadError, code: '100.003'
      expect(subject.generate_code).to eq('100.004')
    end
  end
end